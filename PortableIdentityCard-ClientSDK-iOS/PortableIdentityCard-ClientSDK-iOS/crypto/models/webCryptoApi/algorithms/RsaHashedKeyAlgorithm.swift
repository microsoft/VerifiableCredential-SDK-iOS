//
//  RsaHashedKeyAlgorithm.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class RsaHashedKeyAlgorithm: RsaKeyAlgorithm {
    
    let hash_alg: Algorithm
    
    let keyReference: String?
    
    init(modulusLength: UInt64, publicExponent: UInt64, hash: Algorithm, keyReference: String? = nil) {
        self.hash_alg = hash
        self.keyReference = keyReference
        super.init(modulusLength: modulusLength, publicExponent: publicExponent)
    }

}
