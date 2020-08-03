/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

// Mock Serializer until Serialization layer is implemented
class Serializer {
    
    func deserialize(data: Data) -> Any {
        return String(data: data, encoding: .utf8)! as Any
    }
    
    func serialize(object: Any) -> Data {
        return (object as! String).data(using: .utf8)!
    }
}

// Mock Data Models until Serialization layer is implemented
typealias PresentationRequest = String
typealias PresentationResponse = String
typealias PresentationServiceResponse = String
typealias IssuanceResponse = String
typealias IssuanceServiceResponse = String
typealias ExchangeRequest = String
typealias ExchangeServiceResponse = String
typealias IdentifierDocument = String
typealias Contract = String
