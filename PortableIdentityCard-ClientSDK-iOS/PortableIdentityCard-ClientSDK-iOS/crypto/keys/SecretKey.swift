//
//  SecretKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/3/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/**
   Represents an OCT key
 */
class SecretKey: KeyStoreItem {
    
    let kty: KeyType = KeyType.Octets
    
    let kid: String
    
    let use: KeyUse?
    
    let key_ops: Set<KeyUsage>?
    
    let alg: String?
    
    let k: String?
    
    init(key: JsonWebKey) {
        if var self.kid = key.kid {
        } else {
            self.kid = ""
        }
        self.use = toKeyUse(use: key.use)
        if let key_ops = key.key_ops {
            self.key_ops = key.key_ops?.map { toKeyUsage(key_op: $0) }
        } else {
            self.key_ops = nil
        }
        self.alg = key.alg
    }
    
    /**
       Converts Secret Key to JsonWebKey
       
       - Returns: JsonWebKey version of secret key
     */
    func toJWK() -> JsonWebKey {
        return JsonWebKey(
            kty: self.kty.rawValue,
            kid: self.kid,
            use: self.use?.rawValue,
            key_ops: self.key_ops?.map { $0.rawValue },
            k: k)
    }

}
