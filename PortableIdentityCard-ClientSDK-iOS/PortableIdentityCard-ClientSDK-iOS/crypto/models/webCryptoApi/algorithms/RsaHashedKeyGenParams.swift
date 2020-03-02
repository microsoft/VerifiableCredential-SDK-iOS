//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class RsaHashedKeyGenParams: RsaKeyAlgorithm {
    
    let hashAlgorithm: Algorithm
    
    init(modulusLength: UInt64, publicExponent: UInt64, hash: Algorithm) {
        self.hashAlgorithm = hash
        super.init(modulusLength: modulusLength, publicExponent: publicExponent)
    }
    
    /**
     Decoder Initializer.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        self.hashAlgorithm = try container.decode(Algorithm.self, forKey: .hash)
        try super.init(from: decoder)
    }
    
}
