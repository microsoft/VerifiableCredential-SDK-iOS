/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

// Mock Serializer until Serialization layer is implemented
public class MockSerializer: Serializing {
    public func deserialize<T>(_: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(MockSerializableObject.self, from: data) as! T
    }
    
    public func serialize<T>(object: T) throws -> Data where T : Codable {
        let encoder = JSONEncoder()
        return try encoder.encode(object)
    }
}

public struct MockSerializableObject: Codable, Equatable {
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
