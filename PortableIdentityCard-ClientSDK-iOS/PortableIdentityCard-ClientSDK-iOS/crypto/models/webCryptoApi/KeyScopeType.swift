//
//  KeyType.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/*
    The type of a key
 */
enum KeyScopeType: String, Codable {
    
    case Public = "public"
    case Private = "private"
    
    // Opaque key material, including that used for symmetric algorithms
    case Secret = "secret"

}
