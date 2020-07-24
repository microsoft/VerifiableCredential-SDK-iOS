//
//  mockSerializer.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class Serializer {
    
    func deserialize<T: Decodable>(type: T.Type, data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func serialize<T: Encodable>(object: T) throws -> Data {
        return try JSONEncoder().encode(object)
    }
    
}
