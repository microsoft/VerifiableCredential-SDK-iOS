//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class RsaHashedImportParams: Algorithm {
    
    let hashAlgorithm: Algorithm?
    
    init(hash hashAlgorithm: Algorithm?) {
        self.hashAlgorithm = hashAlgorithm
        super.init(name: W3cCryptoApiConstants.RsaSsaPkcs1V15.rawValue)
    }
    
    /**
     Decoder Initializer.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        self.hashAlgorithm = try container.decodeIfPresent(Algorithm.self, forKey: .hash)
        super.init(name: W3cCryptoApiConstants.RsaSsaPkcs1V15.rawValue)
    }
}
