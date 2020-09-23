/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VcNetworking
import VcJwt

@testable import VCRepository

class NetworkOperationFactoryTests: XCTestCase {
    
    let factory = NetworkOperationFactory()
    let expectedUrl = "https://test235.com"
    
    func testCreateFetchContractOperation() throws {
        let expec = self.expectation(description: "Fire")
        factory.createFetchOperation(FetchContractOperation.self, withUrl: self.expectedUrl).done { operation in
            XCTAssertEqual(operation.urlRequest.url?.absoluteString, self.expectedUrl)
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testCreateUnsupportedOperation() throws {
        let expec = self.expectation(description: "Fire")
        factory.createFetchOperation(MockNetworkOperation.self, withUrl:   self.expectedUrl).done { operation in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is RepositoryError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testCreatePostIssuanceResponseOperation() throws {
        let expec = self.expectation(description: "Fire")
        let requestBody = JwsToken<IssuanceResponseClaims>(from: TestData.issuanceResponse.rawValue)!
        factory.createPostOperation(PostIssuanceResponseOperation.self, withUrl: self.expectedUrl, withRequestBody: requestBody).done { operation in
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testCreateUnsupportedPostOperation() throws {
        let expec = self.expectation(description: "Fire")
        factory.createPostOperation(MockPostNetworkOperation.self, withUrl: self.expectedUrl, withRequestBody: "Test").done { operation in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is RepositoryError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
}
