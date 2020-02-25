//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/*! @see https://www.w3.org/TR/WebCryptoAPI/#dfn-AesGcmParams */
class AesGcmParams: Algorithm {
    
    let length: UInt16?
    
    init(iv: [UInt8], additionalData: [UInt8], tagLength: UInt8, length: UInt16) {
        self.length = length
        super.init(name: W3cCryptoApiConstants.AesGcm.rawValue)
        // iv may be up to 2^64-1 bytes long.
        // tagLength must be enforced between o and 128
    }
    
}
