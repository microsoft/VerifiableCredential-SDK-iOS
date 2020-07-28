//
//  Serializable.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

protocol Serializable {
    func serialize() throws -> Data
    
    static func deserialize(object: Data) throws -> Serializable
}
