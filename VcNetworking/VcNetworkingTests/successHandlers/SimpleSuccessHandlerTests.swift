/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VcNetworking

class SimpleSuccessHandlerTests: XCTestCase {
    
    let handler = SimpleSuccessHandler(serializer: MockSerializer())
    var response = HTTPURLResponse()
    let expectedResponseBody = MockSerializableObject(id: "test")
    let serializer = MockSerializer()

    func testHandleSuccessfulResponse() throws {
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualResponseBody = try handler.onSuccess(MockSerializableObject.self, data: serializedResponseBody, response: response)
        XCTAssertEqual(actualResponseBody, self.expectedResponseBody)
    }

}
