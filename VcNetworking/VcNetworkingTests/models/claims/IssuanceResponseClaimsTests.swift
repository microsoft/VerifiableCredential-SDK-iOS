/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VcNetworking

class IssuanceResponseClaimsTests: XCTestCase {
    
    func testInit() {
        let claims = IssuanceResponseClaims(contract: "testContract", jti: "testJti")
        XCTAssertEqual(claims.contract, "testContract")
        XCTAssertEqual(claims.jti, "testJti")
        XCTAssertNil(claims.scope)
        XCTAssertNil(claims.state)
        XCTAssertNil(claims.nonce)
        XCTAssertNil(claims.iat)
        XCTAssertNil(claims.exp)
        XCTAssertNil(claims.nbf)
        XCTAssertNil(claims.registration)
        XCTAssertNil(claims.iss)
        XCTAssertNil(claims.prompt)
    }
    
}
