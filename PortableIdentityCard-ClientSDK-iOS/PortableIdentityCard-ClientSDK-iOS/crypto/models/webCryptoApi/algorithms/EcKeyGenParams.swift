//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class EcKeyGenParams: Algorithm {
    
    var namedCurve: String
    
    let hashAlgorithm: Algorithm?
    
    let keyReference: String?
    
    init(namedCurve: String, hash hashAlgorithm: Algorithm?=nil, keyReference: String?=nil) {
        self.namedCurve = namedCurve
        self.hashAlgorithm = hashAlgorithm
        self.keyReference = keyReference
        super.init(name: W3cCryptoApiConstants.EcDsa.rawValue)
    }
}
