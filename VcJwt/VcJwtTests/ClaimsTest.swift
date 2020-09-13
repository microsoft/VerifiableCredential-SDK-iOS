/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VcJwt
import XCTest

class ClaimsTest: XCTestCase {
    
    let expectedValue = "test43"

    func testMockClaims() throws {
        let claims = MockClaims(key: expectedValue)
        XCTAssertEqual(claims.iat, "")
        XCTAssertEqual(claims.exp, "")
        XCTAssertEqual(claims.nbf, "")
        XCTAssertEqual(claims.key, expectedValue)
    }
}
