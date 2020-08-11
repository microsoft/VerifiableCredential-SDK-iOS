/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
@testable import VCCrypto

class Random32BytesSecretTests: XCTestCase {
    
    func testNewSecret() throws {
        let store = SecretStoreMock()
        let secret = Random32BytesSecret(withStore: store)!
        
        let value = try store.getSecret(id: secret.id, type: Random32BytesSecret.typeName)
        XCTAssertTrue(value.count == 32)
    }
    
    func testNewSecretsAreDifferent() throws {
        let store = SecretStoreMock()
        let secret1 = Random32BytesSecret(withStore: store)!
        let secret2 = Random32BytesSecret(withStore: store)!
        
        let value1 = try store.getSecret(id: secret1.id, type: Random32BytesSecret.typeName)
        let value2 = try store.getSecret(id: secret2.id, type: Random32BytesSecret.typeName)
        XCTAssertNotEqual(value1, value2)
    }
    
    func testWithUnsafeBytesValueMatchStoredOne() throws {
        let store = SecretStoreMock()
        let secret = Random32BytesSecret(withStore: store)!
        try secret.withUnsafeBytes { (valuePtr) in
            let val = Data(valuePtr)
            XCTAssertEqual(val, try store.getSecret(id: secret.id, type: Random32BytesSecret.typeName))
        }
    }
}
