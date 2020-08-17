/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCSerialization

@testable import VCNetworking

class SimpleSuccessHandlerTests: XCTestCase {
    
    let handler = SimpleSuccessHandler()
    var response = HTTPURLResponse()
    let expectedResponseBody = "responseBody4235"
    let serializer = Serializer()

    func testHandleSuccessfulResponse() throws {
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualResponseBody = try handler.onSuccess(String.self, data: serializedResponseBody, response: response)
        XCTAssertEqual(actualResponseBody, self.expectedResponseBody)
    }

}
