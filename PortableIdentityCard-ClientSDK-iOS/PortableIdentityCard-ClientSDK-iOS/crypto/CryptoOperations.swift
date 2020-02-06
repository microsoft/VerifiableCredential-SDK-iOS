//
//  CryptoOperations.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/3/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/// Class that encompasses all of Crypto
class CryptoOperations: NSObject {
    
    let subtleCryptoFactory: SubtleCryptoFactory
    
    let subtleCrypto: SubtleCrypto
    
    let keyStore: KeyStore
    
    /**
       - Parameters:
          - subtleCrypto: primitive for operations
          - keyStore:  specific keyStore that securely holds keys.
     */
    init(subtleCrypto: SubtleCrypto, keyStore: KeyStore) {
        self.subtleCryptoFactory = SubtleCryptoFactory(defaultSubtleCrypto: subtleCrypto)
        self.subtleCrypto = subtleCrypto
        self.keyStore = keyStore
    }
    
    /**
       Sign payload with key stored in keyStore.
     
       - Parameters:
         - payload to sign
         - signingKeyReference reference to key store in keystore
     
       - Returns: JWT as ByteArray
     */
    public func sign(payload: [UInt8], signingKeyReference: String, algorithm: Algorithm? = nil) throws -> [UInt8] {
        let privateKey = self.keyStore.getPrivateKey(signingKeyReference)
        
        var alg: Algorithm
        
        if algorithm != nil {
            alg = algorithm!
        } else if privateKey.alg != nil {
            alg = privateKey.alg
        } else {
            throw CryptoError.NoAlgorithmSpecifiedForKey(keyName: signingKeyReference)
        }
        
        let subtle = self.subtleCryptoFactory.getMessageSigner(name: alg.name, scope: SubtleCryptoScope.Private)
        let key = subtle.importKey(format: KeyFormat.Jwk, keyData: privateKey.getKey().toJwk(), algorithm: alg, extractable: false, keyUsages: [KeyUsage.Sign])
        return subtle.sign(algorithm: alg, key: key, data: payload)
    }
    
    /**
       Verify payload with key stored in keyStore.
     
       - Parameters:
         - payload to verify
         - signature to verify
         - signingKeyReference reference to key store in keystore
         - algorithm  optional algorithm of signature
     
       - Returns: JWT as ByteArray
     */
    public func verify(payload: [UInt8], signature: [UInt8], signingKeyReference: String, algorithm: Algorithm? = nil) throws {
        let publicKey = self.keyStore.getPrivateKey(keyReference: signingKeyReference)
        
        var alg: Algorithm
        
        if algorithm != nil {
            alg = algorithm!
        } else if publicKey.alg != nil {
            alg = publicKey.alg
        } else {
            throw CryptoError.NoAlgorithmSpecifiedForKey(keyName: signingKeyReference)
        }
        
        let subtle = self.subtleCryptoFactory.getMessageSigner(name: alg.name, scope: SubtleCryptoScope.Public)
        let key = subtle.importKey(format: KeyFormat.Jwk, keyData: publicKey.getKey().toJWK(), algorithm: alg, extractable: true, keyUsages: [KeyUsage.Verify])
        
        if (!subtle.verify(algorithm: alg, key: key, signature: signature, data: payload)) {
            throw CryptoError.InvalidSignature
        }
    }
    
    /**
     Encrypt payload with key stored in keyStore
     */
    public func encrypt() {
        /// TODO: Not Implemented
    }
    
    /**
     Decrypt payload with key stored in keyStore
     */
    public func decrypt() {
        /// TODO: Not Implemented
    }
    
    /**
     Generates a key pair.
     
     - Parameters:
      - keyType: the type of key to generate
     
     - Returns: the associated public key
     */
    public func generateKeyPair(keyReference: String, keyType: KeyType) throws -> PublicKey {
        
        switch keyType {
        case KeyType.Octets:
            throw CryptoError.CannotGenerateSymmetricKey
        case KeyType.RSA:
            let subtle = try self.subtleCryptoFactory.getSharedKeyEncrypter(name: W3cCryptoApiConstants.RsaSsaPkcs1V15.rawValue, scope: SubtleCryptoScope.Private)
            let rsaHashedKeyAlgorithm = RsaHashedKeyAlgorithm(modulusLength: 4096, publicExponent: 65537, hash: Sha.sha256, keyReference: keyReference)
            let keyPair = try subtle.generateKeyPair(algorithm: rsaHashedKeyAlgorithm, extractable: false, keyUsages: [KeyUsage.Encrypt, KeyUsage.Decrypt])
            let rsaPrivateKey = try RsaPrivateKey(jsonWebKey: subtle.exportKeyJwk(key: keyPair.privateKey))
            try self.keyStore.save(keyReference: keyReference, key: rsaPrivateKey)
        case KeyType.EllipticCurve:
            let subtle = try self.subtleCryptoFactory.getMessageSigner(name: W3cCryptoApiConstants.EcDsa.rawValue, scope: SubtleCryptoScope.Private)
            
            
            
        }
    }
    

}
