/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

// Mock Serializer until Serialization layer is implemented
public class Serializer {
    func deserialize(data: Data) -> Any {
        return String(data: data, encoding: .utf8)! as Any
    }
    
    func serialize(object: Any) -> Data {
        return (object as! String).data(using: .utf8)!
    }
}

// Mock Data Models until Serialization layer is implemented
public typealias PresentationRequest = String
public typealias PresentationResponse = String
public typealias PresentationServiceResponse = String
public typealias IssuanceResponse = String
public typealias IssuanceServiceResponse = String
public typealias ExchangeRequest = String
public typealias ExchangeServiceResponse = String
public typealias IdentifierDocument = String
public typealias Contract = String
