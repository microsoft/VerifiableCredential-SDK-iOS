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
        let mockFactory = MockNetworkOperationFactory(result: expectedResult)
        repo = MockRepository(networkOperationFactory: mockFactory)
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
    
    func testGetRequestAndThrowError() throws {
        let expec = self.expectation(description: "Fire")
        let factory = NetworkOperationFactory()
        let repo = MockRepository(networkOperationFactory: factory)
        try repo.getRequest(withUrl: self.expectedUrl).done { actualResult in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssertEqual(error as! RepositoryError, RepositoryError.unsupportedNetworkOperation)
            expec.fulfill()
        }
        wait(for: [expec], timeout: 5)
        
    }
}
