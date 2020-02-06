//
//  EllipticCurvePrivateKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/5/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class EllipticCurvePrivateKey: PrivateKey {
    
    let kid: String
    
    let alg: String?
    
    let kty: KeyType = KeyType.EllipticCurve
    
    let use: KeyUse?
    
    let key_ops: Set<KeyUsage>?
    
    let crv: String
    let x: String
    let y: String
    let d: String
    
    init(jsonWebKey: JsonWebKey) throws {
        
        guard let x = jsonWebKey.x,
              let y = jsonWebKey.y,
              let crv = jsonWebKey.crv,
              let d = jsonWebKey.d else {
                throw CryptoError.JsonWebKeyMalformed
        }
        self.x = x
        self.y = y
        self.crv = crv
        self.d = d
        
        if let kid = jsonWebKey.kid {
            self.kid = kid
        } else {
            self.kid = ""
        }
        
        if let alg = jsonWebKey.alg {
            self.alg = alg
        } else {
            self.alg = JoseConstants.Es256K.rawValue
        }
        
        self.use = toKeyUse(use: jsonWebKey.use)
        
        if let key_ops = jsonWebKey.key_ops {
            self.key_ops = Set(try key_ops.map { try toKeyUsage(key_op: $0) })
        } else {
            self.key_ops = nil
        }
        
        
    }
    
    func toJwk() throws -> JsonWebKey {
        var ops: Set<String>? = nil
        if let key_ops = self.key_ops {
            ops = Set(key_ops.map { $0.rawValue })
        }
        return JsonWebKey(kty: self.kty.rawValue,
                          kid: self.kid,
                          use: self.use?.rawValue,
                          key_ops: ops,
                          alg: self.alg,
                          crv: self.crv,
                          x: self.x,
                          y: self.y,
                          d: self.d)
    }
    
    func getPublicKey() throws -> PublicKey {
        return try EllipticCurvePublicKey(jsonWebKey: self.toJwk())
    }
}
