/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VcNetworking

@testable import VCRepository

class NetworkOperationFactoryTests: XCTestCase {
    
    let factory = NetworkOperationFactory()
    let expectedUrl = "https://test235.com"
    
    func testGetFetchContractOperation() throws {
        let operation = try factory.create(FetchContractOperation.self, withUrl: self.expectedUrl)!
        XCTAssertEqual(operation.urlRequest.url?.absoluteString, expectedUrl)
    }
    
    func testUnsupportedOperation() throws {
        XCTAssertNil(try factory.create(MockNetworkOperation.self, withUrl: self.expectedUrl))
    }
}
