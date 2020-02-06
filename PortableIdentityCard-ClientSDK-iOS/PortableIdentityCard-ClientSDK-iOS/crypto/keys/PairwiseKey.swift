//
//  PairwiseKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/3/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
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
        throw CryptoError.NotImplemented
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
        let alg: Algorithm = EcdsaParams(hash: Sha.sha512)
        let masterJwk = JsonWebKey(kty: KeyType.Octets.rawValue, alg: JoseConstants.Hs512.rawValue, k: (secretKey as! SecretKey).k)
        
        throw CryptoError.NotImplemented
        
    }
}
