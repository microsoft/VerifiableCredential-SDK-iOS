/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VCRepository

class ApiCallsTests: XCTestCase {
    
    func testInit() {
        let apiCalls = ApiCalls(networkOperationFactory: NetworkOperationFactory())
        XCTAssert(apiCalls.networkOperationFactory is NetworkOperationFactory)
    }

}
