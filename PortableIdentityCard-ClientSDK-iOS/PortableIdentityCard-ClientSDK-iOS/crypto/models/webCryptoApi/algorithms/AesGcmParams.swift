//
//  File.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//
// @see https://www.w3.org/TR/WebCryptoAPI/#dfn-AesGcmParams
//

class AesGcmParams: Algorithm {
    
    let length: UInt16?
    
    init(iv: [UInt8], additionalData: [UInt8], tagLength: UInt8, length: UInt16) {
        super.init(name: W3cCryptoApiConstants.AesGcm.rawValue)
        // iv may be up to 2^64-1 bytes long.
        // tagLength must be enforced between o and 128
    }
    
}
