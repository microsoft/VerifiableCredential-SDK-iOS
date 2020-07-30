//
//  Serializer.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

public protocol SerializerProtocol {
    func deserialize<T: Serializable>(_: T.Type, data: Data) throws -> T
    func serialize<T: Serializable>(object: T) throws -> Data
}

public class Serializer: SerializerProtocol {
    
    public init() {}
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    public func deserialize<T: Serializable>(_: T.Type, data: Data) throws -> T {
        return try T.init(with: self, data: data)
    }
    
    public func serialize<T: Serializable>(object: T) throws -> Data {
        return try object.serialize(to: self)
    }
    
}
