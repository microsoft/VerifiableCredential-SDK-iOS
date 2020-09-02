//
//  JwtEncoderTests.swift
//  VcJwtTests
//
//  Created by Sydney Morton on 8/25/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest

@testable import VcJwt

class JwsEncoderTests: XCTestCase {
    
    private let encoder = JwsEncoder()
    private var testToken: JwsToken<MockClaims>!
    private let expectedSignature = "fakeSignature".data(using: .utf8)
    private let expectedHeader = Header(keyId: "test")
    private let expectedContent = MockClaims(key: "value67")
    private let jsonDecoder = JSONDecoder()
    private let encodedHeader = "eyJraWQiOiJ0ZXN0In0"
    private let encodedContent = "eyJrZXkiOiJ2YWx1ZTY3In0"
    

    override func setUpWithError() throws {
        testToken = JwsToken(headers: expectedHeader, content: expectedContent, signature: expectedSignature)
    }

    func testEncodeToken() throws {
        let encodedJws = try encoder.encode(testToken)

        let components = encodedJws.components(separatedBy: ".")
        let actualContents = try jsonDecoder.decode(MockClaims.self, from: Data(base64URLEncoded: components[1])!)
        let actualHeaders = try jsonDecoder.decode(Header.self, from: Data(base64URLEncoded: components[0])!)
        
        XCTAssertEqual(actualContents, expectedContent)
        XCTAssertEqual(actualHeaders.keyId, expectedHeader.keyId)
    }

    func testEncodeThenDecodeToken() throws {
        let encodedJws = try encoder.encode(testToken)
        let decoder = JwsDecoder()
        let result = try decoder.decode(MockClaims.self, token: encodedJws)
        
        XCTAssertEqual(result.content, expectedContent)
        XCTAssertEqual(result.headers.keyId, expectedHeader.keyId)
    }
}