//
//  SubtleCryptoMapItem.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/28/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class SubtleCryptoMapItem: NSObject {
    
    let subtleCrypto: SubtleCrypto
    
    let scope: SubtleCryptoScope
    
    init(subtleCrypto: SubtleCrypto, scope: SubtleCryptoScope) {
        self.subtleCrypto = subtleCrypto
        self.scope = scope
    }

}
