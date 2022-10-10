/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import Secp256k1

enum Secp256k1Error: Error {
    case invalidMessageHash
    case invalidSecretKey
    case signatureFailure
    case invalidSignature
    case invalidPublicKey
    case publicKeyCreationFailure
    case invalidSecret
}

public struct Secp256k1: Signing {
    
    private let publicKey: Secp256k1PublicKey?
    
    private let secret: VCCryptoSecret?
    
    /// Create Secp256k1 object from Secret, for signing.
    public init(secret: VCCryptoSecret) throws {
        self.secret = secret
        self.publicKey = nil
    }
    
    /// Create Secp256k1 object from public key, for verification.
    init(publicKey: PublicKey) throws {
        guard let secpKey = publicKey as? Secp256k1PublicKey else {
            throw Secp256k1Error.invalidPublicKey
        }
        self.publicKey = secpKey
        self.secret = nil
    }
    
    /// Sign a message message hash
    /// - Parameters:
    ///   - messageHash: 32 bytes message
    /// - Returns: The R|S signature
    public func sign(messageHash: Data) throws -> Data {
        
        // Validate params
        guard secret is Secret else { throw Secp256k1Error.invalidSecret }
        guard messageHash.count == 32 else { throw Secp256k1Error.invalidMessageHash }
        
        // Create the context and signature data structure
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
        defer { secp256k1_context_destroy(context) }
        
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer {
            signature.deinitialize(count: 1)
            signature.deallocate()
        }
        
        // Sign the message
        try (secret as! Secret).withUnsafeBytes { (secretPtr) in
            guard secp256k1_ec_seckey_verify(context!, secretPtr.bindMemory(to: UInt8.self).baseAddress.unsafelyUnwrapped) > 0 else { throw Secp256k1Error.invalidSecretKey }
            
            try messageHash.withUnsafeBytes { (msgPtr) in
                let result = secp256k1_ecdsa_sign(
                    context!, // ctx:    pointer to a context object, initialized for signing (cannot be NULL)
                    signature, // sig:    pointer to an array where the signature will be placed (cannot be NULL)
                    msgPtr.bindMemory(to: UInt8.self).baseAddress!, // msg32:  the 32-byte message hash being signed (cannot be NULL)
                    secretPtr.bindMemory(to: UInt8.self).baseAddress!, // seckey: pointer to a 32-byte secret key (cannot be NULL)
                    nil, // noncefp:pointer to a nonce generation function. If NULL, secp256k1_nonce_function_default (secp256k1_nonce_function_rfc6979) is used
                    nil)
                
                guard result == 1 else { throw Secp256k1Error.signatureFailure }
            }
        }
        
        // Convert the signature to a R|S Data object
        var rsSignature = Data(count: 64)
        rsSignature.withUnsafeMutableBytes { (rsSignaturePtr) in
            secp256k1_ecdsa_signature_serialize_compact(context!, rsSignaturePtr.bindMemory(to: UInt8.self).baseAddress!, signature)
            return
        }
        
        return rsSignature
    }
    
    /// Validate a signature
    /// - Parameters:
    ///   - signature: The signature to validate
    ///   - messageHash: The message hash
    /// - Returns: True if the signature is valid
    public func isValidSignature(signature: Data, forMessageHash messageHash: Data) throws -> Bool {
        // Validate params
        guard signature.count == 64 else { throw Secp256k1Error.invalidSignature }
        guard messageHash.count == 32 else { throw Secp256k1Error.invalidMessageHash }
        
        let publicKey = self.publicKey == nil ? try createPublicKey() : self.publicKey!
        
        // Create the context and convert the parsed signature and public key to the appropriate data structure
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))!
        defer { secp256k1_context_destroy(context) }
        
        let normalizedSignature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer {
            normalizedSignature.deinitialize(count: 1)
            normalizedSignature.deallocate()
        }
        
        let parsedSignature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer {
            parsedSignature.deinitialize(count: 1)
            parsedSignature.deallocate()
        }
        signature.withUnsafeBytes({ (signaturePtr) in
            secp256k1_ecdsa_signature_parse_compact(context, parsedSignature, signaturePtr.bindMemory(to: UInt8.self).baseAddress!)
            return
        })
        
        let parsedPubKey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        try publicKey.uncompressedValue.withUnsafeBytes { (publicKeyPtr) in
            let result = secp256k1_ec_pubkey_parse(
                context,
                parsedPubKey,
                publicKeyPtr.bindMemory(to: UInt8.self).baseAddress!,
                65)
            guard result > 0 else { throw Secp256k1Error.invalidPublicKey}
        }
        
        // Normalize the signature
        secp256k1_ecdsa_signature_normalize(context, normalizedSignature, parsedSignature)
        
        // Validate signature
        var isValid = false
        messageHash.withUnsafeBytes { (msgPtr) in
            isValid = secp256k1_ecdsa_verify(context, normalizedSignature, msgPtr.bindMemory(to: UInt8.self).baseAddress!, parsedPubKey) == 1
        }
        
        return isValid
    }
    
    public func getPublicKey() throws -> PublicKey {
        return try createPublicKey() as PublicKey
    }
    
    private func createPublicKey() throws -> Secp256k1PublicKey {
        guard let secret = secret else {
            throw Secp256k1Error.invalidSecret
        }
        
        let (_, publicKey) = try self.createKeyPair(forSecret: secret)
        return publicKey
    }
    
    /// Create a key pair from a secret
    /// - Parameter secret: The Secret used to generate the public key
    /// - Returns: The key pair
    public func createKeyPair(forSecret secret: VCCryptoSecret) throws -> (EphemeralSecret, Secp256k1PublicKey)
    {
        // Validate params
        guard secret is Secret else { throw Secp256k1Error.invalidSecret }
        
        // Get out the private key data
        let privateKey = try EphemeralSecret(with: secret)

        // Return with the public key
        return (privateKey, try self.createPublicKey(forPrivateKey: privateKey))
    }
    
    /// Create a public key from a private key
    /// - Parameter secret: The Secret used to generate the public key
    /// - Returns: The public key
    public func createPublicKey(forPrivateKey privateKey: EphemeralSecret) throws -> Secp256k1PublicKey {
        
        // Create the context and public key data structure
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(context) }
        let pubkey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)

        // Populate it
        try privateKey.withUnsafeBytes { (secretPtr) in
            let result = secp256k1_ec_pubkey_create(
                context,
                pubkey,
                secretPtr.bindMemory(to: UInt8.self).baseAddress!)
            
            guard result > 0 else { throw Secp256k1Error.publicKeyCreationFailure }
        }
        
        // Serialize the public key
        var publicKey = Data(count: 65)
        let outputlen = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        outputlen.pointee = publicKey.count
        publicKey.withUnsafeMutableBytes { (publicKeyPtr) in
            secp256k1_ec_pubkey_serialize(
                context,
                publicKeyPtr.bindMemory(to: UInt8.self).baseAddress!,
                outputlen,
                pubkey,
                UInt32(SECP256K1_EC_UNCOMPRESSED))
            return
        }
        
        // Wrap it all up
        return Secp256k1PublicKey(uncompressedPublicKey: publicKey)!
    }
}
