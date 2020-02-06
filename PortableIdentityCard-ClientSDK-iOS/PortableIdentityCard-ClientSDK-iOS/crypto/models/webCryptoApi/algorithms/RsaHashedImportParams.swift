//
//  RsaHashedImportParams.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/30/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class RsaHashedImportParams: Algorithm {
    
    let alg_hash: Algorithm?
    
    init(hash alg_hash: Algorithm?) {
        self.alg_hash = alg_hash
        super.init(name: W3cCryptoApiConstants.RsaSsaPkcs1V15.rawValue)
    }
}
