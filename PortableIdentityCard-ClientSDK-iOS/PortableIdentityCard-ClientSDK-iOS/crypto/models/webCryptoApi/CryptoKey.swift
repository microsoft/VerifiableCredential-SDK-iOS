//
//  CryptoKey.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

class CryptoKey: NSObject, Codable {
    
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
