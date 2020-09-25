/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VCEntities

class IssuanceResponseClaimsTests: XCTestCase {
    
    func testInit() {
        let claims = IssuanceResponseClaims()
        XCTAssertEqual(claims.scope, "")
        XCTAssertEqual(claims.state, "")
        XCTAssertEqual(claims.nonce, "")
        XCTAssertNil(claims.iat)
        XCTAssertNil(claims.exp)
        XCTAssertNil(claims.nbf)
        XCTAssertEqual(claims.registration, RegistrationClaims())
        XCTAssertEqual(claims.issuer, "https://self-issued.me")
        XCTAssertEqual(claims.prompt, "")
    }
    
}
