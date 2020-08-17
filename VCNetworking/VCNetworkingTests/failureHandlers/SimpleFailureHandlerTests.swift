/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCSerialization

@testable import VCNetworking

class SimpleFailureHandlerTests: XCTestCase {
    
    let handler = SimpleFailureHandler()
    let expectedResponseBody = "responseBody4235"
    let serializer = Serializer()

    func testHandleResponseFailureBadRequest() throws {
        let response = self.createHttpURLResponse(statusCode: 400)
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualError = try handler.onFailure(data: serializedResponseBody, response: response)
        XCTAssertEqual(actualError, NetworkingError.badRequest(withBody: self.expectedResponseBody))
    }
    
    func testHandleResponseFailureUnauthorized() throws {
        let response = self.createHttpURLResponse(statusCode: 401)
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualError = try handler.onFailure(data: serializedResponseBody, response: response)
        XCTAssertEqual(actualError, NetworkingError.unauthorized(withBody: self.expectedResponseBody))
    }
    
    func testHandleResponseFailureForbidden() throws {
        let response = self.createHttpURLResponse(statusCode: 403)
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualError = try handler.onFailure(data: serializedResponseBody, response: response)
        XCTAssertEqual(actualError, NetworkingError.forbidden(withBody: self.expectedResponseBody))
    }
    
    func testHandleResponseFailureNotFound() throws {
        let response = self.createHttpURLResponse(statusCode: 404)
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualError = try handler.onFailure(data: serializedResponseBody, response: response)
        XCTAssertEqual(actualError, NetworkingError.notFound(withBody: self.expectedResponseBody))
    }
    
    func testHandleResponseFailureServiceError() throws {
        let response = self.createHttpURLResponse(statusCode: 500)
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualError = try handler.onFailure(data: serializedResponseBody, response: response)
        XCTAssertEqual(actualError, NetworkingError.serverError(withBody: self.expectedResponseBody))
    }
    
    func testHandleResponseFailureUnknownError() throws {
        let response = self.createHttpURLResponse(statusCode: 600)
        let serializedResponseBody = try serializer.serialize(object: expectedResponseBody)
        let actualError = try handler.onFailure(data: serializedResponseBody, response: response)
        XCTAssertEqual(actualError, NetworkingError.unknownNetworkingError(withBody: self.expectedResponseBody))
    }
    
    private func createHttpURLResponse(statusCode: Int) -> HTTPURLResponse {
        let url = URL(string: "testUrl.com")!
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }

}
