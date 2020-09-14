/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VcNetworking
import VcJwt

@testable import VCRepository

class IssuanceRepositoryTests: XCTestCase {
    
    var repo: IssuanceRepository!
    let expectedResult = "Result235"
    let expectedUrl = "https://test352.com"
    
    override func setUpWithError() throws {
        let mockFactory = MockNetworkOperationFactory(result: expectedResult)
        repo = IssuanceRepository(apiCalls: MockApiCalls(factory: mockFactory))
    }
    
    func testInit() {
        let repo = IssuanceRepository()
        XCTAssert(repo.apiCalls is ApiCalls)
    }
    
    func testGetCalled() {
        let expec = self.expectation(description: "Fire")
        repo.getRequest(withUrl: expectedUrl).done { actualResult in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(MockApiCalls.wasGetCalled)
            XCTAssert(error is MockIssuanceRepoError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testPostCalled() {
        let expec = self.expectation(description: "Fire")
        let token = JwsToken<IssuanceResponseClaims>(from: TestData.issuanceResponse.rawValue)!
        repo.sendResponse(usingUrl: expectedUrl, withBody: token).done { actualResult in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(MockApiCalls.wasPostCalled)
            XCTAssert(error is MockIssuanceRepoError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }

}
