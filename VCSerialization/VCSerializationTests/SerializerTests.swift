//
//  ContractTests.swift
//  serializationTests
//
//  Created by Sydney Morton on 7/28/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest

@testable import VCSerialization

class SerializerTests: XCTestCase {
    
    var serializer: Serializer!
    let expectedContract = MockContract(test: "test", id: "42")
    var expectedSerializedContract: Data!

    override func setUpWithError() throws {
        let encoder = JSONEncoder()
        expectedSerializedContract = try encoder.encode(expectedContract)
        serializer = Serializer()
    }

    func testDeserializingContract() throws {
        let contract = try serializer.deserialize(MockContract.self, data: expectedSerializedContract)
        XCTAssertEqual(contract.id, "42")
        XCTAssertEqual(contract.test, "test")
    }
    
    func testSerializingContract() throws {
        let actualSerializedContract = try serializer.serialize(object: expectedContract)
        XCTAssertEqual(actualSerializedContract, expectedSerializedContract)
    }

}
