//
//  PropertyWrapper.swift
//  VcNetworking
//
//  Created by Sydney Morton on 9/16/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

@propertyWrapper
public struct DefaultEmptyArray<T:Codable> {
    public var wrappedValue: [T] = []
    
    public init() {}
}

//codable extension to encode/decode the wrapped value
extension DefaultEmptyArray: Codable {
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode([T].self)
    }
    
}

extension KeyedDecodingContainer {
    func decode<T:Decodable>(_ type: DefaultEmptyArray<T>.Type,
                forKey key: Key) throws -> DefaultEmptyArray<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
