/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VCSerialization

class JwsTokenTests: XCTestCase {
    
    let expectedHeaders = ["key": "value"]
    let expectedContent = "expectedContent"
    let expectedSignature = "signature"
    
    let serializer = Serializer()
    var expectedSerializedToken: Data!

    override func setUpWithError() throws {
        let encodedHeaders = try serializer.encoder.encode(expectedHeaders)
        let stringifiedHeaders = String(data: encodedHeaders, encoding: .utf8)!.toBase64URL()
        self.expectedSerializedToken = "\(stringifiedHeaders).\(expectedContent).\(expectedSignature)".data(using: .utf8)
        
    }

    func testJwsTokenDeserialization() throws {
        let actualToken = try serializer.deserialize(JwsToken.self, data: self.expectedSerializedToken)
        XCTAssertEqual(actualToken.headers, expectedHeaders)
        XCTAssertEqual(actualToken.content, expectedContent)
        XCTAssertEqual(actualToken.signature, expectedSignature.data(using: .utf8))
        // XCTAssertEqual(actualToken.raw, expectedSerializedToken)
    }
    
    func testJwsTokenSerialization() throws {
        let actualToken = try serializer.deserialize(JwsToken.self, data: self.expectedSerializedToken)
        let actualSerializedToken = try serializer.serialize(object: actualToken)
        // XCTAssertEqual(actualSerializedToken, actualToken.raw)
        // XCTAssertEqual(actualSerializedToken, expectedSerializedToken)
    }
}
