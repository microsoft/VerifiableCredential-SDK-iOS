//
//  IssuanceServiceResponseTests.swift
//  serializationTests
//
//  Created by Sydney Morton on 8/7/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest
import VcJwt

@testable import VCSerialization

class IssuanceServiceResponseTests: XCTestCase {
    
    var expectedToken: JwsToken<VcClaims>!
    
//    override func setUpWithError() throws {
//        let headers = Header(type: "expectedType")
//        let mockVcDescriptor = VerifiableCredentialDescriptor(context: ["context"], type: ["type"], credentialSubject: ["key": "value"], credentialStatus: nil, exchangeService: nil, revokeService: nil)
//        let mockVcClaims = VcClaims(jti: "id", iss: "issuer did", sub: "sub", vc: mockVcDescriptor)
//        expectedToken = JwsToken<VcClaims>(headers: headers, content: mockVcClaims, signature: Data(count: 64))
//    }
//
//    let serializer = Serializer()
//
//    func testResponseSerialization() throws {
//        let jwsEncoder = JwsEncoder()
//        let expectedResponse = IssuanceServiceResponse(token: expectedToken)
//        let serializedResponse = try serializer.serialize(object: expectedResponse)
//        let actualResponse = try jwsEncoder.encode(expectedToken).data(using: .utf8)!
//        XCTAssertEqual(actualResponse, serializedResponse)
//    }
    
    func test() {
        XCTAssertEqual("hello", "hello")
    }
}
