//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class RsaPublicKey: PublicKey {
    
    var kid: String
    
    let kty: KeyType = KeyType.RSA
    
    let use: KeyUse?
    
    let key_ops: Set<KeyUsage>?
    
    let alg: String?
    
    let n: String
    
    let e: String
    
    init(jsonWebKey: JsonWebKey) throws {
        
        guard let n = jsonWebKey.n, let e = jsonWebKey.e else {
            throw CryptoError.JsonWebKeyMalformed
        }
        
        if let kid = jsonWebKey.kid {
            self.kid = kid
        } else {
            self.kid = ""
        }
        
        self.use = toKeyUse(use: jsonWebKey.use)
        self.alg = jsonWebKey.alg
        
        if let key_ops = jsonWebKey.key_ops {
            self.key_ops = Set(try key_ops.map { try toKeyUsage(key_op: $0) })
        } else {
            self.key_ops = nil
        }
        
        self.n = n
        self.e = e
        
    }
    
    func minimumAlphabeticJwk() -> String {
        return "{\"e\":\"\(self.e)\",\"kty\":\"\(self.kty.rawValue)\",\"n\":\"\(self.n)\"}"
    }
    
    func toJwk() throws -> JsonWebKey {
        
        var ops: Set<String>?
        if let key_ops = self.key_ops {
            ops = Set(key_ops.map { $0.rawValue })
        } else {
            ops = nil
        }
        return JsonWebKey(kty: self.kty.rawValue,
                          kid: self.kid,
                          use: self.use?.rawValue,
                          key_ops: ops,
                          alg: self.alg,
                          n: self.n,
                          e: self.e)
    }

}
