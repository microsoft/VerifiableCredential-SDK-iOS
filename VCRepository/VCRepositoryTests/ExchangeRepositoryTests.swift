/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCNetworking
import VCEntities

@testable import VCRepository

class ExchangeRepositoryTests: XCTestCase {
    
    var repo: ExchangeRepository!
    let expectedResult = "Result235"
    let expectedUrl = "https://test352.com"
    
    override func setUpWithError() throws {
        let mockFactory = MockNetworkOperationFactory(result: expectedResult)
        repo = ExchangeRepository(apiCalls: MockApiCalls(factory: mockFactory))
    }
    
    func testPostCalled() {
        let expec = self.expectation(description: "Fire")
        let token = ExchangeRequest(from: TestData.exchangeRequest.rawValue)!
        
        repo.sendResponse(usingUrl: expectedUrl, withBody: token).done { actualResult in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(MockApiCalls.wasPostCalled)
            XCTAssert(error is MockRepoError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }

}
