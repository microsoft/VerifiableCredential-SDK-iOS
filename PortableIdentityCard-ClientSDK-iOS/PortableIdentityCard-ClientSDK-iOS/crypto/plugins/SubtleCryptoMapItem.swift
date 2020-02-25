//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

class SubtleCryptoMapItem: NSObject {
    
    let subtleCrypto: SubtleCrypto
    
    let scope: SubtleCryptoScope
    
    init(subtleCrypto: SubtleCrypto, scope: SubtleCryptoScope) {
        self.subtleCrypto = subtleCrypto
        self.scope = scope
    }

}
