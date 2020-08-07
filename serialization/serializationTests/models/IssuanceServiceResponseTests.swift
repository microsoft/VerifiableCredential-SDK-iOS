//
//  IssuanceServiceResponseTests.swift
//  serializationTests
//
//  Created by Sydney Morton on 8/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest

@testable import serialization

class IssuanceServiceResponseTests: XCTestCase {
    
    let serializer = Serializer()

    func testResponseDeserialization() throws {
        let expectedVcData = "testVc".data(using: .utf8)!
        let expectedResponse = IssuanceServiceResponse(vc: expectedVcData)
        let encoder = JSONEncoder()
        let serializedResponse = try encoder.encode(expectedResponse)
        let actualResponse = try serializer.deserialize(IssuanceServiceResponse.self, data: serializedResponse)
        XCTAssertEqual(actualResponse, expectedResponse)
    }
}
