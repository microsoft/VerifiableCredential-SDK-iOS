/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VcNetworking

class IssuanceResponseClaimsTests: XCTestCase {
    
    func testInit() {
        let claims = IssuanceResponseClaims()
        XCTAssertEqual(claims.scope, "")
        XCTAssertEqual(claims.state, "")
        XCTAssertEqual(claims.nonce, "")
        XCTAssertEqual(claims.iat, "")
        XCTAssertEqual(claims.exp, "")
        XCTAssertEqual(claims.nbf, "")
        XCTAssertEqual(claims.registration, RegistrationClaims())
        XCTAssertEqual(claims.iss, "")
        XCTAssertEqual(claims.prompt, "")
    }
    
}
