//
//  RsaOaepParams.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class RsaOaepParams: Algorithm {
    
    let label: [UInt8]?
    
    let hashAlgorithm: Algorithm?
    
    init(label: [UInt8]?=nil, hash hashAlgorithm: Algorithm?=nil) {
        self.label = label
        self.hashAlgorithm = hashAlgorithm
        super.init(name: W3cCryptoApiConstants.RsaOaep.rawValue)
    }

}
