//
//  KeyStoreListItem.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 2/4/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

struct KeyStoreListItem: Codable {
    
    let kty: KeyType
    
    var kids: [String]
    
    init(keyType kty: KeyType, keyIds kids: [String]) {
        self.kty = kty
        self.kids = kids
    }
    
    func getLatestKeyId() -> String? {
        return self.kids.first
    }

}
