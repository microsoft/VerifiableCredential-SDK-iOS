//
//  Serializer.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class Serializer {

    var data: Data? = nil

    func deserialize<T: Serializable>(_: T.Type, data: Data) throws -> T {
        self.data = data
        return try T.init(with: self, data: data)
    }
    
    func serialize<T: Serializable>(object: T) throws -> Data {
        return try object.serialize(to: self)
    }
    
}
