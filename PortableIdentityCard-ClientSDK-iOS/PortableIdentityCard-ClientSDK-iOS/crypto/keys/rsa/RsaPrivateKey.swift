//
//  RsaPrivateKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/5/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//


class RsaPrivateKey: PrivateKey {
    
    /// Required Parameters for RSA Private Key
    var alg: String?
    
    var kty: KeyType = KeyType.RSA
    
    var kid: String
    
    var use: KeyUse?
    
    var key_ops: Set<KeyUse>?

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
        
        self.key_ops = jsonWebKey.key_ops?.map { toKeyUse(use: $0) }
        self.use = toKeyUse(use: jsonWebKey.use)

        self.p = jsonWebKey.p
        self.q = jsonWebKey.q
        self.dp = jsonWebKey.dp
        self.dq = jsonWebKey.dq
        self.qi = jsonWebKey.qi
    }

    func toJwk() throws -> JsonWebKey {
        return JsonWebKey(kty: self.kty.rawValue,
                          kid: self.kid,
                          use: self.use?.rawValue,
                          key_ops: self.key_ops?.map { $0.rawValue },
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
        return try RsaPublicKey(self.toJwk())
    }

}
