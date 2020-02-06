//
//  EcdsaParams.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class EcdsaParams: Algorithm {
    
    var hash_alg: Algorithm
    
    let namedCurve: String
    
    let format: String?
    
    init(hash: Algorithm, namedCurve: String, format: String) {
        self.hash_alg = hash
        self.namedCurve = namedCurve
        self.format = format
        super.init(name: "W3cCryptoApiConstants.EcDsa.rawValue")
    }
    
}
