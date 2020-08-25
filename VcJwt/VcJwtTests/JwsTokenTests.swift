/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VcJwt
import VcCrypto
import XCTest

class JwsTokenTests: XCTestCase {
    
    private var testToken: JwsToken<MockClaims>!
    private let expectedHeader = Header(keyId: "actualKid43")
    private let expectedContent = MockClaims(key: "value523")

    override func setUpWithError() throws {
        testToken = JwsToken(headers: expectedHeader, content: expectedContent, signature: nil)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        XCTAssertEqual(testToken.content, expectedContent)
        XCTAssertEqual(testToken.headers.keyId, expectedHeader.keyId)
        XCTAssertEqual(testToken.signature, nil)
    }

    func testSigning() throws {
        let signer = MockSigner()
        let secret = MockVcSecret(id: UUID())
        try testToken.sign(using: signer, usingSecret: secret)
        XCTAssertEqual(testToken.signature, "fakeSignature".data(using: .utf8)!)
    }

}
