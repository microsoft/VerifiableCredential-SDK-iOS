//
//  JwtEncoderTests.swift
//  VcJwtTests
//
//  Created by Sydney Morton on 8/25/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest

@testable import VcJwt

class JwtEncoderTests: XCTestCase {
    
    private let encoder: JwsEncoder = JwsEncoder()
    private var testToken: JwsToken<MockClaims>!
    private let expectedSignature = Data()
    private let expectedHeader = Header(keyId: "actualKid43")
    private let expectedContent = MockClaims(key: "value523")
    private let jsonDecoder = JSONDecoder()

    override func setUpWithError() throws {
        testToken = JwsToken(headers: expectedHeader, content: expectedContent, signature: expectedSignature)
    }

    func testEncodeToken() throws {
        let encodedJws = try encoder.encode(testToken)
        print(encodedJws)
        let components = encodedJws.components(separatedBy: ".")
        print(components)
        let data = Data(base64URLEncoded: components[0])!
        let actualContents = try jsonDecoder.decode(MockClaims.self, from: Data(base64URLEncoded: components[1])!)
        XCTAssertEqual(actualContents, expectedContent)
        print(String(data: data, encoding: .utf8))
        let actualHeaders = try jsonDecoder.decode(Header.self, from: Data(base64URLEncoded: components[0])!)
        XCTAssertEqual(actualHeaders.keyId, expectedHeader.keyId)
    }

    func testPerformanceExample() throws {
        let compact = "eyJraWQiOiJhY3R1YWxLaWQ0MyJ9.eyJrZXkiOiJ2YWx1ZTUyMyJ9."
        let decoder = JwsDecoder()
        let result = try decoder.decode(MockClaims.self, token: compact)
        print(result.content)
        
    }

}
