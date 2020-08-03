//
//  SimpleSuccessHandlerTests.swift
//  networkingTests
//
//  Created by Sydney Morton on 8/3/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest

class SimpleSuccessHandlerTests: XCTestCase {
    
    let handler = SimpleSuccessHandler()
    var response = HTTPURLResponse()
    let expectedResponseBody = "responseBody4235"
    let serializer = Serializer()

    func testHandleSuccessfulResponse() throws {
        let serializedResponseBody = serializer.serialize(object: expectedResponseBody)
        let actualResponseBody = try handler.onSuccess(String.self, data: serializedResponseBody, response: response)
        XCTAssertEqual(actualResponseBody, self.expectedResponseBody)
    }

}
