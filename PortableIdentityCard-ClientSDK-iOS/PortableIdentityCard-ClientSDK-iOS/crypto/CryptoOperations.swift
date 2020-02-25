//
//  Copyright (C) Microsoft Corporation. All rights reserved.
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
        let privateKeyContainer = try self.keyStore.getPrivateKey(keyReference: signingKeyReference)
        let privateKey = privateKeyContainer.getKey() as! PrivateKey
        
        var alg: Algorithm
        
        if algorithm != nil {
            alg = algorithm!
        } else if privateKey.alg != nil {
            alg = privateKeyContainer.alg!
        } else {
            throw CryptoError.NoAlgorithmSpecifiedForKey(keyName: signingKeyReference)
        }
        
        let subtle = try self.subtleCryptoFactory.getMessageSigner(name: alg.name, scope: SubtleCryptoScope.Private)
        let key = try subtle.importKey(format: KeyFormat.Jwk, keyData: try privateKey.toJwk(), algorithm: alg, extractable: false, keyUsages: [KeyUsage.Sign])
        return try subtle.sign(algorithm: alg, key: key, data: payload)
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
        let publicKeyContainer = try self.keyStore.getPublicKey(keyReference: signingKeyReference)
        let publicKeyOptional = publicKeyContainer.getKey()
        
        guard let publicKey = publicKeyOptional else {
            throw CryptoError.NoKeyFoundFor(keyName: signingKeyReference)
        }
        
        var alg: Algorithm
        
        if algorithm != nil {
            alg = algorithm!
        } else if publicKeyContainer.alg != nil {
            alg = publicKeyContainer.alg!
        } else {
            throw CryptoError.NoAlgorithmSpecifiedForKey(keyName: signingKeyReference)
        }
        
        let subtle = try self.subtleCryptoFactory.getMessageSigner(name: alg.name, scope: SubtleCryptoScope.Public)
        let key = try subtle.importKey(format: KeyFormat.Jwk, keyData: try (publicKey as! PublicKey).toJwk(), algorithm: alg, extractable: true, keyUsages: [KeyUsage.Verify])
        
        if (try !subtle.verify(algorithm: alg, key: key, signature: signature, data: payload)) {
            throw CryptoError.InvalidSignature
        }
    }
    
    /**
     Encrypt payload with key stored in keyStore
     */
    public func encrypt() throws {
        throw CryptoError.NotImplemented
        /// TODO: Not Implemented
    }
    
    /**
     Decrypt payload with key stored in keyStore
     */
    public func decrypt() throws {
        throw CryptoError.NotImplemented
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
            let ecAlgorithm = EcKeyGenParams(namedCurve: W3cCryptoApiConstants.Secp256k1.rawValue, hash: Sha.sha256, keyReference: keyReference)
            let keyPair = try subtle.generateKeyPair(algorithm: ecAlgorithm, extractable: true, keyUsages: [KeyUsage.Verify, KeyUsage.Sign])
            let ecPrivateKey = try EllipticCurvePrivateKey(jsonWebKey: subtle.exportKeyJwk(key: keyPair.privateKey))
            try self.keyStore.save(keyReference: keyReference, key: ecPrivateKey)
        }
        
        if let publicKey = try self.keyStore.getPublicKey(keyReference: keyReference).getKey() {
            return (publicKey as! PublicKey)
        }
        /// maybe should through different error to explain why key was not saved properly?
        throw CryptoError.NoKeyFoundFor(keyName: keyReference)
    }
    
    /**
     Generate a pairwise key.
     
     - Parameters:
       - seed to be used to create pairwise key.
     */
    public func generatePairwise(seed: String) throws {
        throw CryptoError.NotImplemented
    }
    
    /**
     Generate a seed.
     */
    public func generateSeed() throws -> String {
        throw CryptoError.NotImplemented
    }
}
