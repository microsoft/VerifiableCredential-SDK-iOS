//
//  Serializable.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

protocol Serializable {
    init (with serializer: Serializer, data: Data) throws
    
    func serialize(to: Serializer) throws -> Data
}

extension Serializable where Self: Codable {
    func serialize(to: Serializer) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    init(with serializer: Serializer, data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}
