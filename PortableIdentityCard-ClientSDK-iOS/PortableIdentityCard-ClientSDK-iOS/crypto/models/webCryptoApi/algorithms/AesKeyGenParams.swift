//
//  AesKeyGenParams.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class AesKeyGenParams: Algorithm {
    
    var length: UInt16
    
    init(name: String, length: UInt16) {
        self.length = length
        super.init(name: name)
    }
}
