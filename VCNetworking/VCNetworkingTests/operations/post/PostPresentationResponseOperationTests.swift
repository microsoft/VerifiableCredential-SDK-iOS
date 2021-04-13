/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import PromiseKit
import VCEntities

@testable import VCNetworking

class PostPresentionResponseOperationTests: XCTestCase {
    private var postOperation: PostPresentationResponseOperation!
    private let expectedUrl = "https://testcontract.com/4235"
    private let expectedHttpResponse = "testPresentationResponse29384"
    private let expectedRequestBody = PresentationResponse(from: TestData.presentationResponse.rawValue)!
    private let encoder = PresentationResponseEncoder()
    private var expectedEncodedBody: Data!

    override func setUpWithError() throws {
        self.expectedEncodedBody = try encoder.encode(value: expectedRequestBody)

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        postOperation = try PostPresentationResponseOperation(usingUrl: self.expectedUrl, withBody: expectedRequestBody, urlSession: urlSession)
    }

    func testSuccessfulInit() throws {
        XCTAssertTrue(postOperation.successHandler is SimpleSuccessHandler)
        XCTAssertTrue(postOperation.failureHandler is SimpleFailureHandler)
        XCTAssertTrue(postOperation.retryHandler is NoRetry)
        XCTAssertEqual(postOperation.urlRequest.url!.absoluteString, expectedUrl)
        XCTAssertEqual(postOperation.urlRequest.url!.absoluteString, expectedUrl)
        XCTAssertEqual(postOperation.urlRequest.httpBody!, self.expectedEncodedBody)
        XCTAssertEqual(postOperation.urlRequest.httpMethod!, Constants.POST)
        XCTAssertEqual(postOperation.urlRequest.value(forHTTPHeaderField: Constants.CONTENT_TYPE)!, Constants.FORM_URLENCODED)
    }

    func testInvalidUrlInit() {
        let invalidUrl = ""
        XCTAssertThrowsError(try PostPresentationResponseOperation(usingUrl: invalidUrl, withBody: expectedRequestBody)) { error in
            XCTAssertEqual(error as! NetworkingError, NetworkingError.invalidUrl(withUrl: invalidUrl))
        }
    }
}
