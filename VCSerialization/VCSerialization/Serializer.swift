//
//  Serializer.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import VcJwt

public enum SerializationError: Error {
    case nullData
    case unableToStringifyData(withData: Data)
    case malFormedObject(withData: Data)
}

public protocol Serializing {
    func deserialize<T: Serializable>(_: T.Type, data: Data) throws -> T
    func serialize<T: Serializable>(object: T) throws -> Data
}

public class Serializer: Serializing {
    
    public init() {}
    
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    let jwsDecoder = JwsDecoder()
    let jwsEncoder = JwsEncoder()

    public func deserialize<T: Serializable>(_: T.Type, data: Data) throws -> T {
        return try T.init(with: self, data: data)
    }
    
    public func serialize<T: Serializable>(object: T) throws -> Data {
        return try object.serialize(to: self)
    }
    
}
