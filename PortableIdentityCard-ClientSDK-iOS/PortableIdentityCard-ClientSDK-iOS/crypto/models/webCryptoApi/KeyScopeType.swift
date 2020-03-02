//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

/**
    The type of a key
 */
enum KeyScopeType: String, Codable {
    
    case Public = "public"
    case Private = "private"
    
    // Opaque key material, including that used for symmetric algorithms
    case Secret = "secret"

}
