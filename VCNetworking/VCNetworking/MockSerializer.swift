/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCSerialization

// Mock Serializer until Serialization layer is implemented
public class MockSerializer: Serializing {
    public func deserialize<T>(_: T.Type, data: Data) throws -> T where T : Serializable {
        return String(data: data, encoding: .utf8)! as! T
    }
    
    public func serialize<T>(object: T) throws -> Data where T : Serializable {
        return (object as! String).data(using: .utf8)!
    }
}

public struct MockSerializableObject: Serializable, Codable, Equatable {
    let id: String
}

// Mock Data Models until Serialization layer is implemented
public typealias MockPresentationRequest = MockSerializableObject
public typealias MockPresentationResponse = MockSerializableObject
public typealias MockPresentationServiceResponse = MockSerializableObject
public typealias MockIssuanceResponse = MockSerializableObject
public typealias MockIssuanceServiceResponse = MockSerializableObject
public typealias MockExchangeRequest = MockSerializableObject
public typealias MockExchangeServiceResponse = MockSerializableObject
public typealias MockIdentifierDocument = MockSerializableObject
public typealias MockContract = MockSerializableObject
