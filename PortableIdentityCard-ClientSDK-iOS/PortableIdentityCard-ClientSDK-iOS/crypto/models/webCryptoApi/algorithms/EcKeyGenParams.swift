//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class EcKeyGenParams: Algorithm {
    
    var namedCurve: String
    
    let hashAlgorithm: Algorithm?
    
    let keyReference: String?
    
    init(hash hashAlgorithm: Algorithm?=nil, namedCurve: String, keyReference: String?=nil) {
        self.namedCurve = namedCurve
        self.hashAlgorithm = hashAlgorithm
        self.keyReference = keyReference
        super.init(name: W3cCryptoApiConstants.EcDsa.rawValue)
    }
    
    /**
     Decoder Initializer.
     */
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        let hashAlgorithm = try container.decode(Algorithm.self, forKey: .hash)
        let namedCurve = try container.decode(String.self, forKey: .namedCurve)
        let keyReference = try container.decodeIfPresent(String.self, forKey: .keyReference)
        self.init(hash: hashAlgorithm, namedCurve: namedCurve, keyReference: keyReference)
    }
}
