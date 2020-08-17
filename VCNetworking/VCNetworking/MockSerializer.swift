/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCSerialization

// Mock Serializer until Serialization layer is implemented
public class MockSerializer: SerializerProtocol {
    public func deserialize<T>(_: T.Type, data: Data) throws -> T where T : Serializable {
        return String(data: data, encoding: .utf8)! as! T
    }
    
    public func serialize<T>(object: T) throws -> Data where T : Serializable {
        return (object as! String).data(using: .utf8)!
    }
}

// Mock Data Models until Serialization layer is implemented
public typealias MockPresentationRequest = String
public typealias MockPresentationResponse = String
public typealias MockPresentationServiceResponse = String
public typealias MockIssuanceResponse = String
public typealias MockIssuanceServiceResponse = String
public typealias MockExchangeRequest = String
public typealias MockExchangeServiceResponse = String
public typealias MockIdentifierDocument = String
public typealias MockContract = String
