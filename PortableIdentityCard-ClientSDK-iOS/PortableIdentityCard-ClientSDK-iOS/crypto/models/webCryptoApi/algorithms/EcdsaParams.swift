//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class EcdsaParams: Algorithm {
    
    var hash_alg: Algorithm
    
    let namedCurve: String
    
    let format: String?
    
    init(hash: Algorithm, namedCurve: String=W3cCryptoApiConstants.Secp256r1.rawValue, format: String?=nil) {
        self.hash_alg = hash
        self.namedCurve = namedCurve
        self.format = format
        super.init(name: "W3cCryptoApiConstants.EcDsa.rawValue")
    }
    
}
