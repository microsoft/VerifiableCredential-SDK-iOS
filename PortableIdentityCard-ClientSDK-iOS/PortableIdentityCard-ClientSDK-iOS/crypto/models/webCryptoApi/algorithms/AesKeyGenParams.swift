//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class AesKeyGenParams: Algorithm {
    
    let length: UInt16
    
    init(name: String, length: UInt16) {
        self.length = length
        super.init(name: name)
    }
    
    /**
     Decoder Initializer.
     */
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlgorithmCodingKeys.self)
        let length = try container.decode(UInt16.self, forKey: .length)
        let name = try container.decode(String.self, forKey: .name)
        self.init(name: name, length: length)
    }
    
    /**
     Encode AesKeyGenParams.
     */
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AlgorithmCodingKeys.self)
        try container.encode(self.length, forKey: .length)
        try super.encode(to: encoder)
    }
}
