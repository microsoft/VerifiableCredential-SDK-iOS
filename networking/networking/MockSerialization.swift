//
//  mockSerializer.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

// Mock Serializer until Serialization layer is implemented
class Serializer {
    
    func deserialize(data: Data) throws -> Any {
        return String(data: data, encoding: .utf8)! as Any
    }
    
    func serialize(object: Any) throws -> Data {
        return (object as! String).data(using: .utf8)!
    }
}

// Mock Data Models until Serialization layer is implemented
typealias PresentationRequest = String
typealias PresentationServiceResponse = String
typealias IssuanceServiceResponse = String
typealias ExchangeServiceResponse = String
typealias IdentifierDocument = String
typealias Contract = String
