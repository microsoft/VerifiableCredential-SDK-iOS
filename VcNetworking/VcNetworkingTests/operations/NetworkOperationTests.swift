///*---------------------------------------------------------------------------------------------
//*  Copyright (c) Microsoft Corporation. All rights reserved.
//*  Licensed under the MIT License. See License.txt in the project root for license information.
//*--------------------------------------------------------------------------------------------*/
//
//import Foundation
//import XCTest
//import PromiseKit
//
//@testable import VcNetworking
//
//class NetworkOperationTests: XCTestCase {
//    private var fetchContractOperation: FetchMockContractOperation!
//    private let expectedUrl = "https://testcontract.com/4235"
//    private let expectedHttpResponse = MockSerializableObject(id: "test")
//    private var serializedExpectedResponse: String!
//
//    override func setUpWithError() throws {
//        let configuration = URLSessionConfiguration.default
//        configuration.protocolClasses = [UrlProtocolMock.self]
//        let urlSession = URLSession.init(configuration: configuration)
//        do {
//            fetchContractOperation = try FetchMockContractOperation(withUrl: expectedUrl, session: urlSession)
//        } catch {
//            print(error)
//        }
//        let encoder = JSONEncoder()
//        let encodedResponse = try encoder.encode(expectedHttpResponse)
//        serializedExpectedResponse = String(data: encodedResponse, encoding: .utf8)!
//    }
//
//    func testSuccessfulFetchOperation() throws {
//        try UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, statusCode: 200)
//        let expec = self.expectation(description: "Fire")
//
//        fetchContractOperation.fire().done { response in
//            print(response)
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//
//        wait(for: [expec], timeout: 5)
//    }
//
//    func testFailedFetchOperationBadRequestBody() throws {
//        try UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, statusCode: 400)
//        let expec = self.expectation(description: "Fire")
//
//        fetchContractOperation.fire().done { response in
//            print(response)
//            expec.fulfill()
//            XCTFail()
//        }.catch { error in
//            print(error)
//            XCTAssertEqual(error as! NetworkingError, NetworkingError.badRequest(withBody: self.serializedExpectedResponse))
//            expec.fulfill()
//        }
//
//        wait(for: [expec], timeout: 10)
//    }
//
//}
