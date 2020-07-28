//
//  ContractTests.swift
//  serializationTests
//
//  Created by Sydney Morton on 7/28/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest

class ContractTests: XCTestCase {
    
    var serializer: Serializer!
    let expectedContract = Contract(test: "test", id: "42", dict: ["hi": "bye"])
    var expectedSerializedContract: Data!

    override func setUpWithError() throws {
        let encoder = JSONEncoder()
        expectedSerializedContract = try encoder.encode(expectedContract)
        serializer = Serializer()
    }

    func testDeserializingContract() throws {
        let contract = try serializer.deserialize(Contract.self, data: expectedSerializedContract)
        XCTAssertEqual(contract.id, "42")
        XCTAssertEqual(contract.test, "test")
        XCTAssertEqual(contract.dict["hi"], "bye")
    }
    
    func testSerializingContract() throws {
        let actualSerializedContract = try serializer.serialize(object: expectedContract)
        XCTAssertEqual(actualSerializedContract, expectedSerializedContract)
    }

}
