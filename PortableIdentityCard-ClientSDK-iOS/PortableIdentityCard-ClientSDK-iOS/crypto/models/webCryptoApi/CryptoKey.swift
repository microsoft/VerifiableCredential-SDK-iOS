//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class CryptoKey: NSObject {
    
    let type: KeyScopeType
    
    let extractable: Bool
    
    let algorithm: Algorithm
    
    let usages: Set<KeyUsage>
    
    // let handle: Any?
    
    init(type: KeyScopeType,
         extractable: Bool,
         algorithm: Algorithm,
         usages: Set<KeyUsage>) {
        self.type = type
        self.extractable = extractable
        self.algorithm = algorithm
        self.usages = usages
       // self.handle = handle
    }
}
