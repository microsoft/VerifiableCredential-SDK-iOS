/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import PromiseKit
import VcNetworking
import VcJwt

@testable import VCRepository

class RepositoryTests: XCTestCase {

    var repo: MockRepository!
    let expectedUrl = "https://test235.com"
    let expectedResult = "result2343"

    override func setUpWithError() throws {
        repo = MockRepository(result: expectedResult)
    }

    func testGetRequest() throws {
        let expec = self.expectation(description: "Fire")
        try repo.getRequest(withUrl: self.expectedUrl).done { actualResult in
            XCTAssert(MockNetworkOperation.wasFireCalled)
            XCTAssertEqual(self.expectedResult, actualResult)
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
            expec.fulfill()
        }
        wait(for: [expec], timeout: 5)
    }
//
//    func testSendResponse() throws {
//        let encodedToken = TestData.issuanceResponse.rawValue.data(using: .utf8)!
//        let expectedToken = JwsToken<IssuanceResponseClaims>(from: encodedToken)!
//        let expectedResponse = IssuanceServiceResponse(vc: try expectedToken.serialize())
//        try UrlProtocolMock.createMockResponse(response: expectedToken, encodedResponse: encodedToken, url: expectedUrl, statusCode: 200)
//        let expec = self.expectation(description: "Fire")
//        try repo.sendIssuanceResponse(withUrl: self.expectedUrl, withBody: expectedToken).done { actualResponse in
//            XCTAssertEqual(expectedToken.content.exp, actualResponse.content.exp)
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//            expec.fulfill()
//        }
//        wait(for: [expec], timeout: 5)
//
//    }
}
