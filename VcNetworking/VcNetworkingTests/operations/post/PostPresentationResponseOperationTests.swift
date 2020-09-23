/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import PromiseKit
import VCJwt

@testable import VCNetworking

class PostIssuanceResponseOperationTests: XCTestCase {
    private var postPresentationResponseOperation: PostIssuanceResponseOperation!
    private let expectedUrl = "https://testcontract.com/4235"
    private let expectedHttpResponse = "testPresentationResponse29384"
    private let expectedRequestBody = JwsToken<IssuanceResponseClaims>(from: TestData.issuanceResponse.rawValue)!
    private let encoder = IssuanceResponseEncoder()
    private var expectedEncodedBody: Data!

    override func setUpWithError() throws {
        self.expectedEncodedBody = try encoder.encode(value: expectedRequestBody)

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        postPresentationResponseOperation = try PostIssuanceResponseOperation(withUrl: self.expectedUrl, withBody: expectedRequestBody, urlSession: urlSession)
    }

    func testSuccessfulInit() throws {
        XCTAssertTrue(postPresentationResponseOperation.successHandler is SimpleSuccessHandler)
        XCTAssertTrue(postPresentationResponseOperation.failureHandler is SimpleFailureHandler)
        XCTAssertTrue(postPresentationResponseOperation.retryHandler is NoRetry)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.url!.absoluteString, expectedUrl)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.url!.absoluteString, expectedUrl)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.httpBody!, self.expectedEncodedBody)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.httpMethod!, Constants.POST)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.value(forHTTPHeaderField: Constants.CONTENT_TYPE)!, Constants.PLAIN_TEXT)
    }

    func testInvalidUrlInit() {
        let invalidUrl = ""
        XCTAssertThrowsError(try PostIssuanceResponseOperation(withUrl: invalidUrl, withBody: expectedRequestBody)) { error in
            XCTAssertEqual(error as! NetworkingError, NetworkingError.invalidUrl(withUrl: invalidUrl))
        }
    }
}
