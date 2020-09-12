/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VcNetworking

@testable import VCRepository

class IssuanceRepositoryTests: XCTestCase {
    
    func testInit() {
        let repo = IssuanceRepository()
        XCTAssert(repo.networkOperationFactory is NetworkOperationFactory)
    }

}
