//
//  RsaHashKeyGenParams.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class RsaHashedKeyGenParams: RsaKeyAlgorithm {
    
    let hash_alg: Algorithm
    
    init(modulusLength: UInt64, publicExponent: UInt64, hash: Algorithm) {
        self.hash_alg = hash
        super.init(modulusLength: modulusLength, publicExponent: publicExponent)
    }

}
