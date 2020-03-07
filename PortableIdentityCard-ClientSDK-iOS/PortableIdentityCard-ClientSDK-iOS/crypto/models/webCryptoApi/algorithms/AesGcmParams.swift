//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/// @see https://www.w3.org/TR/WebCryptoAPI/#dfn-AesGcmParams
class AesGcmParams: Algorithm {
    
    let iv: [UInt8]
    
    let additionalData: [UInt8]
    
    let tagLength: UInt8
    
    let length: UInt16?
    
    init(iv: [UInt8], additionalData: [UInt8], tagLength: UInt8, length: UInt16) {
        self.length = length
        self.iv = iv
        self.additionalData = additionalData
        self.tagLength = tagLength
        super.init(name: W3cCryptoApiConstants.AesGcm.rawValue)
        // iv may be up to 2^64-1 bytes long.
        // tagLength must be enforced between o and 128
    }
    
    /**
     Decoder Initializer.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        self.iv = try container.decode([UInt8].self, forKey: .iv)
        self.additionalData = try container.decode([UInt8].self, forKey: .additionalData)
        self.tagLength = try container.decode(UInt8.self, forKey: .tagLength)
        self.length = try container.decodeIfPresent(UInt16.self, forKey: .length)
        super.init(name: W3cCryptoApiConstants.AesGcm.rawValue)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AlgorithmCodingKeys.self)
        try container.encode(self.iv, forKey: .iv)
        try container.encode(self.additionalData, forKey: .additionalData)
        try container.encode(self.tagLength, forKey: .tagLength)
        try container.encodeIfPresent(self.length, forKey: .length)
        try super.encode(to: encoder)
    }
    
}
