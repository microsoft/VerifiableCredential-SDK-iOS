//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class AesKeyGenParams: Algorithm {
    
    var length: UInt16
    
    init(name: String, length: UInt16) {
        self.length = length
        super.init(name: name)
    }
}
