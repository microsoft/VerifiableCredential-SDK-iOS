//
//  PublicKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/31/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/**
  Represents a Public Key in JWK Format
 */
protocol PublicKey: KeyStoreItem {
    
    // key type
    var kty: KeyType { get }
    
    // Key ID
    var kid: String { get }
    
    // Intended use
    var use: KeyUse? { get }
    
    // Valid key operations
    var key_ops: Set<KeyUsage>? { get }
    
    // Algorithm intended for use with this key
    var alg: String? { get }
    
    /**
      Gets the minimum JWK with parameters in alphabetical order as specified by JWK thumbprint
     
      - see: https://tools.ietf.org/html/rfc7638
     */
    func minimumAlphabeticJwk() throws -> String
    
    /**
       From Public Key to JSON Web Key
     */
    func toJwk() throws -> JsonWebKey
}

extension PublicKey {
    
    /**
      Obtains the thumbprint for the JWK Parameter
     
      - Parameters:
        - crypto crypto operations supported
        - sha sha hashing algorithm
     
      - Returns:
        - the thumbprint of the public key
     */
    func getThumbprint(crypto: CryptoOperations, sha: Algorithm = Sha.sha512) throws -> String {
        let json = try self.minimumAlphabeticJwk()
        let jsonUtf8: [UInt8] = Array(json.utf8)
        let digest = try crypto.subtleCryptoFactory.getMessageDigest(name: sha.name, scope: SubtleCryptoScope.Public)
        let hash = try digest.digest(algorithm: sha, data: jsonUtf8)
        let data = NSData(bytes: hash, length: hash.count)
        return data.base64EncodedString()
    }
}
