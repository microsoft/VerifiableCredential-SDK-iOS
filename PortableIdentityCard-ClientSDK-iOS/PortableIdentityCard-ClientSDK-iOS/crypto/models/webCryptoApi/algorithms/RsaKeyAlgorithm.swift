//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class RsaKeyAlgorithm: Algorithm {
    
    var modulusLength: UInt64
    
    var publicExponent: UInt64
    
    init(modulusLength: UInt64, publicExponent: UInt64) {
        self.modulusLength = modulusLength
        self.publicExponent = publicExponent
        super.init(name: W3cCryptoApiConstants.RsaSsaPkcs1V15.rawValue)
    }
    
    /**
     Decoder Initializer.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        self.modulusLength = try container.decode(UInt64.self, forKey: .modulusLength)
        self.publicExponent = try container.decode(UInt64.self, forKey: .publicExponent)
        super.init(name: W3cCryptoApiConstants.RsaSsaPkcs1V15.rawValue)
    }
    
}
