//
//  Serializer.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class Serializer {
    func deserialize<T: Serializable>(_: T.Type, data: Data) throws -> T {
        return try T.deserialize(object: data) as! T
    }
    
    func serialize<T: Serializable>(object: T) throws -> Data {
        return try object.serialize()
    }
    
}
