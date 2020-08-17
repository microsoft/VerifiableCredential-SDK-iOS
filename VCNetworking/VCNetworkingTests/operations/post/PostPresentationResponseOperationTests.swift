/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import PromiseKit
import VCSerialization

@testable import VCNetworking

class PostPresentationRequestTests: XCTestCase {
    private var postPresentationResponseOperation: PostPresentationResponseOperation!
    private let expectedUrl = "https://testcontract.com/4235"
    private let expectedHttpResponse = "testPresentationResponse29384"
    private let expectedRequestBody = "requestBody2543"
    private let serializer = Serializer()
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        do {
            postPresentationResponseOperation = try PostPresentationResponseOperation(withUrl: self.expectedUrl, withBody: expectedRequestBody, urlSession: urlSession)
        } catch {
            print(error)
        }
    }
    
    func testSuccessfulInit() throws {
        let expectedSerializedBody = try serializer.serialize(object: expectedRequestBody)
        XCTAssertTrue(postPresentationResponseOperation.successHandler is SimpleSuccessHandler)
        XCTAssertTrue(postPresentationResponseOperation.failureHandler is SimpleFailureHandler)
        XCTAssertTrue(postPresentationResponseOperation.retryHandler is NoRetry)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.url!.absoluteString, expectedUrl)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.url!.absoluteString, expectedUrl)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.httpBody!, expectedSerializedBody)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.httpMethod!, Constants.POST)
        XCTAssertEqual(postPresentationResponseOperation.urlRequest.value(forHTTPHeaderField: Constants.CONTENT_TYPE)!, Constants.FORM_URLENCODED)
    }
    
    func testInvalidUrlInit() {
        let invalidUrl = ""
        XCTAssertThrowsError(try PostPresentationResponseOperation(withUrl: invalidUrl, withBody: "testResponse")) { error in
            XCTAssertEqual(error as! NetworkingError, NetworkingError.invalidUrl(withUrl: invalidUrl))
        }
    }
}
