//
//  KeyContainer.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/3/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/**
   Key Container to hold multiple keys with same key type.
 */
class KeyContainer: NSObject {
    
    let kty: KeyType
    
    var keys: [KeyStoreItem]
    
    let use: KeyUse?
    
    let alg: Algorithm?
    
    init(kty: KeyType, keys: [KeyStoreItem], use: KeyUse?, alg: Algorithm?) {
        self.kty = kty
        self.keys = keys
        self.use = use
        self.alg = alg
    }
    
    /**
       Obtain key with id from key container, or returns nil if no key found.
     
       - Parameters:
         - withId: string id of the key to obtain or nil if want first key.
     
       - Returns:
         - key with id or first key found if no id given.
     */
    func getKey(withId id: String?=nil) -> KeyStoreItem? {
        guard id == nil else {
            return self.keys.first
        }
        return self.keys.first { $0.kid == id }
    }

}
