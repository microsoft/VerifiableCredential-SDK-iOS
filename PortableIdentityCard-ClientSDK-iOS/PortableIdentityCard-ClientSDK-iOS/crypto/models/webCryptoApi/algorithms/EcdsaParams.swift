//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class EcdsaParams: Algorithm {
    
    var hashAlgorithm: Algorithm
    
    let namedCurve: String
    
    let format: String?
    
    init(hash: Algorithm, namedCurve: String=W3cCryptoApiConstants.Secp256r1.rawValue, format: String?=nil) {
        self.hashAlgorithm = hash
        self.namedCurve = namedCurve
        self.format = format
        super.init(name: "W3cCryptoApiConstants.EcDsa.rawValue")
    }
    
    /**
     Decoder Initializer.
     */
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        let hashAlgorithm = try container.decode(Algorithm.self, forKey: .hash)
        let namedCurve = try container.decode(String.self, forKey: .namedCurve)
        let format = try container.decodeIfPresent(String.self, forKey: .format)
        self.init(hash: hashAlgorithm, namedCurve: namedCurve, format: format)
    }
    
}
