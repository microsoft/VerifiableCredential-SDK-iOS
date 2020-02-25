//
//  PairwiseKey.swift
//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/// Class to model pairwise keys
class PairwiseKey: NSObject {

    private var masterKeys = [String: [UInt8]]()
    
    private let crypto: CryptoOperations
    
    init(crypto: CryptoOperations) {
        self.crypto = crypto
    }
    
    /**
       Generate a pairwise key for the specified algorithms
     
       - Parameters:
         - algorithm: for the key
         - seedReference: reference to the seed
         - personaId: Id for the persona
         - peerId: Id for the peer
     
       - Returns: a private key generated from seed and other parameters
     */
    public func generatePairwiseKey(algorithm: Algorithm, seedReference: String, personaId: String, peerId: String) throws -> PrivateKey {
        let personaMasterKey = try self.generatePersonaMasterKey(seedReference, personaId)
        let keyType = try KeyTypeFactory.createViaWebCrypto(algorithm: algorithm)
        switch keyType {
        case KeyType.EllipticCurve:
            print(personaMasterKey)
            throw CryptoError.NotImplemented
        case KeyType.RSA:
            throw CryptoError.NotImplemented
        default:
            throw CryptoError.UnknownKeyType(keyType: keyType.rawValue)
        }
    }
    
    /**
       Generate a pairwise master key
     
       - Parameters:
         - seedReference: the master seed for generating pairwise keys
         - personaId: The owner DID
     
       - Returns: ByteArray representation of Private Key
     */
    private func generatePersonaMasterKey(_ seedReference: String, _ personaId: String) throws -> [UInt8] {
        
        if let mk = self.masterKeys[personaId] {
            return mk
        }
        
        // get seed
        let keyContainer = try self.crypto.keyStore.getSecretKey(keyReference: seedReference)
        let secretKeyOptional = keyContainer.getKey()
        
        guard let secretKey = secretKeyOptional else {
            throw CryptoError.NoKeyFoundFor(keyName: seedReference)
        }
        
        // get the subtle crypto
        let subtleCrypto: SubtleCrypto = try self.crypto.subtleCryptoFactory.getMessageAuthenticationCodeSigners(name: W3cCryptoApiConstants.Hmac.rawValue, scope: SubtleCryptoScope.Private)
        
        // generate the master key
        let algorithm: Algorithm = EcdsaParams(hash: Sha.sha512)
        let masterJwk = JsonWebKey(kty: KeyType.Octets.rawValue, alg: JoseConstants.Hs512.rawValue, k: (secretKey as! SecretKey).k)
        let key = try subtleCrypto.importKey(format: KeyFormat.Jwk, keyData: masterJwk, algorithm: algorithm, extractable: false, keyUsages: [KeyUsage.Sign])
        
        let masterKey = try subtleCrypto.sign(algorithm: algorithm, key: key, data: [UInt8](personaId.utf8))
        
        self.masterKeys[personaId] = masterKey
        return masterKey
    }
}
