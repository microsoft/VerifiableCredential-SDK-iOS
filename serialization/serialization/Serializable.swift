//
//  Serializable.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

public protocol Serializable {
    init (with serializer: Serializer, data: Data) throws
    
    func serialize(to serializer: Serializer) throws -> Data
}

public extension Serializable where Self: Codable {
    func serialize(to serializer: Serializer) throws -> Data {
        return try serializer.encoder.encode(self)
    }
    
    init(with serializer: Serializer, data: Data) throws {
        self = try serializer.decoder.decode(Self.self, from: data)
    }
}

public protocol JSONSerializable: Codable & Serializable {}
