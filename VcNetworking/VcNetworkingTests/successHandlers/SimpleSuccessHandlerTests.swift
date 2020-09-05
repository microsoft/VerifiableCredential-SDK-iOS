/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VcNetworking

class SimpleSuccessHandlerTests: XCTestCase {
    
    let handler = SimpleSuccessHandler(decoder: MockDecoder())
    var response = HTTPURLResponse()
    let expectedResponseBody = MockObject(key: "test")
    let encoder = JSONEncoder()

    func testHandleSuccessfulResponse() throws {
        let serializedResponseBody = try encoder.encode(expectedResponseBody)
        let actualResponseBody = try handler.onSuccess(data: serializedResponseBody)
        XCTAssertEqual(actualResponseBody, self.expectedResponseBody)
    }

}
