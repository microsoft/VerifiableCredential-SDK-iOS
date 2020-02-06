//
//  RsaPrivateKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/5/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//


class RsaPrivateKey: NSObject, PrivateKey {
    
    /// Required Parameters for RSA Private Key
    var alg: String?
    
    var kty: KeyType = KeyType.RSA
    
    var kid: String
    
    var use: KeyUse?
    
    var key_ops: Set<KeyUsage>?

    let n: String

    let e: String

    let d: String

    /// Optional Parameters
    let p: String?
    let q: String?
    let dp: String?
    let dq: String?
    let qi: String?

    init(jsonWebKey: JsonWebKey) throws {
        
        if let keyId = jsonWebKey.kid {
            self.kid = keyId
        } else {
            self.kid = ""
        }

        guard let n = jsonWebKey.n, let e = jsonWebKey.e, let d = jsonWebKey.d else {
            throw CryptoError.JsonWebKeyMalformed
        }
        
        self.n = n
        self.e = e
        self.d = d

        if jsonWebKey.alg == nil {
            self.alg = JoseConstants.Rs256.rawValue
        } else {
            self.alg = jsonWebKey.alg
        }
        
        if let key_ops = jsonWebKey.key_ops {
            self.key_ops = Set(try key_ops.map { try toKeyUsage(key_op: $0) })
        }
        
        self.use = toKeyUse(use: jsonWebKey.use)

        self.p = jsonWebKey.p
        self.q = jsonWebKey.q
        self.dp = jsonWebKey.dp
        self.dq = jsonWebKey.dq
        self.qi = jsonWebKey.qi
    }

    func toJwk() -> JsonWebKey {
        
        var ops: Set<String>? = nil
        if let key_ops = self.key_ops {
            ops = Set(key_ops.map { $0.rawValue })
        }
        return JsonWebKey(kty: self.kty.rawValue,
                          kid: self.kid,
                          use: self.use?.rawValue,
                          key_ops: ops,
                          alg: self.alg,
                          d: self.d,
                          n: self.n,
                          e: self.e,
                          p: self.p,
                          q: self.q,
                          dp: self.dp,
                          dq: self.dq,
                          qi: self.qi)
    }
    
    func getPublicKey() throws -> PublicKey {
        let jwkForm = self.toJwk()
        return try RsaPublicKey(jsonWebKey: jwkForm)
    }

}
