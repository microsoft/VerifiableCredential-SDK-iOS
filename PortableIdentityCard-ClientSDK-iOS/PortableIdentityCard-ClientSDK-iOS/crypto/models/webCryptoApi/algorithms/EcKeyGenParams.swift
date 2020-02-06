//
//  EcKeyGenParams.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class EcKeyGenParams: Algorithm {
    
    var namedCurve: String
    
    let hashAlgorithm: Algorithm?
    
    let keyReference: String?
    
    init(namedCurve: String, hash hashAlgorithm: Algorithm?=nil, keyReference: String?=nil) {
        self.namedCurve = namedCurve
        self.hashAlgorithm = hashAlgorithm
        self.keyReference = keyReference
        super.init(name: W3cCryptoApiConstants.EcDsa.rawValue)
    }

}
