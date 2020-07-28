//
//  Serializable.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

protocol Serializable {
    init (from serializer: Serializer)
    
    func serialize(to: Serializer) throws -> Data
}

extension Serializable {
    init(from serializer: Serializer) throws {
        guard let data = serializer.data else {
            throw SerializationError.nullData
        }
    }
}
