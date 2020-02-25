//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//
/**
   Represents an OCT key
 */
class SecretKey: KeyStoreItem {
    
    let kid: String
    
    let kty: KeyType = KeyType.Octets
    
    let use: KeyUse?
    
    let key_ops: Set<KeyUsage>?
    
    let alg: String?
    
    let k: String?
    
    init(key: JsonWebKey) throws {
        
        guard let k = key.k else {
            throw CryptoError.JsonWebKeyMalformed
        }
        self.k = k
        
        var keyId: String
        if let kid = key.kid {
            keyId = kid
        } else {
            keyId = ""
        }
        self.kid = keyId
        
        
        self.use = toKeyUse(use: key.use)
        self.alg = key.alg
        
        if let key_ops = key.key_ops {
            self.key_ops = Set(try key_ops.map { try toKeyUsage(key_op: $0) })
        } else {
            self.key_ops = nil
        }
    }
    
    /**
     Converts Secret Key to JsonWebKey
     
     - Returns: JsonWebKey version of secret key
     */
    func toJWK() -> JsonWebKey {
        
        if let key_ops = self.key_ops {
            return JsonWebKey(
                kty: self.kty.rawValue,
                kid: self.kid,
                use: self.use?.rawValue,
                key_ops: Set(key_ops.map { $0.rawValue }),
                k: k)
        } else {
            return JsonWebKey(
                kty: self.kty.rawValue,
                kid: self.kid,
                use: self.use?.rawValue,
                key_ops: nil,
                k: k)
        }
    }
}
