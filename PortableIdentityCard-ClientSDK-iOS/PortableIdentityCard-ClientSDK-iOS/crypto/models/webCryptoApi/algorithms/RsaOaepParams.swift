//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class RsaOaepParams: Algorithm {
    
    let label: [UInt8]?
    
    let hashAlgorithm: Algorithm?
    
    init(label: [UInt8]?=nil, hash hashAlgorithm: Algorithm?=nil) {
        self.label = label
        self.hashAlgorithm = hashAlgorithm
        super.init(name: W3cCryptoApiConstants.RsaOaep.rawValue)
    }
    
    /**
     Decoder Initializer.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        self.label = try container.decodeIfPresent([UInt8].self, forKey: .label)
        self.hashAlgorithm = try container.decodeIfPresent(Algorithm.self, forKey: .hash)
        super.init(name: W3cCryptoApiConstants.RsaOaep.rawValue)
    }
    
}
