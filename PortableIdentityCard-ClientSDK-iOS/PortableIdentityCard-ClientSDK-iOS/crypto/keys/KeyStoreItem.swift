//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

protocol KeyStoreItem: Codable {
    var kid: String { get }
    
    var kty: KeyType { get }
}
