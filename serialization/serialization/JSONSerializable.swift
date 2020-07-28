//
//  JSONSerializable.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

protocol JSONSerializable: Serializable, Codable {}


//extension JSONSerializable {
//    func serialize() throws -> Data {
//        let encoder = JSONEncoder()
//        return try encoder.encode(self)
//    }
//    
//    static func deserialize(object: Data) throws -> Any {
//        let decoder = JSONDecoder()
//        return try decoder.decode(JSONSerializable.Type, from: object) as! JSONSerializable
//    }
//}
