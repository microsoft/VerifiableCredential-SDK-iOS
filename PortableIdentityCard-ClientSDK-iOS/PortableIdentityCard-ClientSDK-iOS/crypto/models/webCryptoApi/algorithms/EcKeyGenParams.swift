//
//  EcKeyGenParams.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class EcKeyGenParams: Algorithm {
    
    var namedCurve: String
    
    init(namedCurve: String) {
        self.namedCurve = namedCurve
        super.init(name: W3cCryptoApiConstants.EcDsa.rawValue)
    }

}
