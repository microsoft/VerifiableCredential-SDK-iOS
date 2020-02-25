//
//  Copyright (C) Microsoft Corporation. All rights reserved.
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
