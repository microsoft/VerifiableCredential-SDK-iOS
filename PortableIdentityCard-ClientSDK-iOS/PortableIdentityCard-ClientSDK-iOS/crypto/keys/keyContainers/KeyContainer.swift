//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

import Foundation

/**
   Key Container to hold multiple keys with same key type.
 */
class KeyContainer: NSObject, Codable {
    
    /// CodingKeys for encoding and decoding key container
    enum CodingKeys: String, CodingKey {
        case keyType = "kty"
        case keys = "keys"
        case use = "use"
        case alg = "alg"
    }
    
    /// Key type of the key container.
    let kty: KeyType
    
    /// An array of KeyStoreItems contained in this container.
    var keys: [KeyStoreItem]
    
    /// Optional key use object to describe what use the keys in the container can be used for.
    let use: KeyUse?
    
    /// Optional algorithm object to describe what algorithm is used for keys in the container.
    let alg: Algorithm?
    
    init(kty: KeyType, keys: [KeyStoreItem], use: KeyUse?, alg: Algorithm?) {
        self.kty = kty
        self.keys = keys
        self.use = use
        self.alg = alg
    }
    
    /**
     Encode Key Container using encoder.
     
     - Parameters:
      - encoder: that is used to encode object for external representation
     */
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kty, forKey: .keyType)
        try container.encode(keys, forKey: .keys)
        try container.encodeIfPresent(use, forKey: .use)
        try container.encodeIfPresent(alg, forKey: .alg)
    }
    
    /**
     Decode Key Container using decoder.
     
     - Parameters:
      - decoder: that is used to decode external representation into key container object.
    */
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // decode keyType
        let keyType = try container.decode(KeyType.self, forKey: .keyType)
        
        // decode keys
        let keys = try container.decode([KeyStoreItem].self, forKey: .keys)
        
        // decode keyUse if key in json exists
        let keyUse = try container.decodeIfPresent(KeyUse.self, forKey: .use)

        //decode algorithm if key in json exists
        let alg = try container.decodeIfPresent(Algorithm.self, forKey: .alg)
        
        self.init(kty: keyType, keys: keys, use: keyUse, alg: alg)
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
