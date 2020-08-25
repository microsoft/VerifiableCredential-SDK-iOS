/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VcJwt
import XCTest

class Secp256k1Tests: XCTestCase {
    
    private let signer = Secp256k1Signer()
    private let verifier = Secp256k1Verifier()
    private var testToken: JwsToken<MockClaims>!
    private let expectedSignature = Data()
    private let expectedHeader = Header(keyId: "actualKid43")
    private let expectedContent = MockClaims(key: "value523")

    override func setUpWithError() throws {
        testToken = JwsToken(headers: expectedHeader, content: expectedContent, signature: nil)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSigner() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testVerifierWithNoSignature() throws {
        testToken = JwsToken(headers: expectedHeader, content: expectedContent, signature: nil)
        let result = try verifier.verify(token: testToken, publicKeys: [])
        XCTAssertEqual(result, false)
    }

}
