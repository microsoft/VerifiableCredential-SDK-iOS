//
//  JsonWebKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

struct JsonWebKey: Codable {
    
    /// The following fields are defined in Section 3.1 of JSON Web Key
    let kty: String
    let kid: String?
    let use: String?
    let key_ops: Set<String>?
    let alg: String?
    
    /// The following fields are defined in JSON Web Key Parameters Registration
    let ext: Bool?
    
    /// The following fields are defined in Section 6 of JSON Web Algorithms
    let crv: String?
    let x: String?
    let y: String?
    let d: String?
    let n: String?
    let e: String?
    let p: String?
    let q: String?
    let dp: String?
    let dq: String?
    let qi: String?
    let k: String?
    
    init(kty: String,
         kid: String?=nil,
         use: String?=nil,
         key_ops: Set<String>?=nil,
         alg: String?=nil,
         ext: Bool?=nil,
         crv: String?=nil,
         x: String?=nil,
         y: String?=nil,
         d: String?=nil,
         n: String?=nil,
         e: String?=nil,
         p: String?=nil,
         q: String?=nil,
         dp: String?=nil,
         dq: String?=nil,
         qi: String?=nil,
         k: String?=nil) {
        self.kty = kty
        self.kid = kid
        self.use = use
        self.key_ops = key_ops
        self.alg = alg
        self.ext = ext
        self.crv = crv
        self.x = x
        self.y = y
        self.d = d
        self.n = n
        self.e = e
        self.p = p
        self.q = q
        self.dp = dp
        self.dq = dq
        self.qi = qi
        self.k = k
    }

}
