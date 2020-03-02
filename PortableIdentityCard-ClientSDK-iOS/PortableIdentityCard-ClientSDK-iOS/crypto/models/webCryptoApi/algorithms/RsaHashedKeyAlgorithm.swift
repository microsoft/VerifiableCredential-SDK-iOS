//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class RsaHashedKeyAlgorithm: RsaKeyAlgorithm {
    
    let hashAlgorithm: Algorithm
    
    let keyReference: String?
    
    init(modulusLength: UInt64, publicExponent: UInt64, hash: Algorithm, keyReference: String? = nil) {
        self.hashAlgorithm = hash
        self.keyReference = keyReference
        super.init(modulusLength: modulusLength, publicExponent: publicExponent)
    }
    
    /**
     Decoder Initializer.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        self.hashAlgorithm = try container.decode(Algorithm.self, forKey: .hash)
        self.keyReference = try container.decodeIfPresent(String.self, forKey: .keyReference)
        try super.init(from: decoder)
    }
    
}
