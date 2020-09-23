/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation


import XCTest
@testable import VcCrypto

class KeychainSecretStoreTests: XCTestCase {
    
    func testSaveAndRetrieve() throws {
        var secret = Data(repeating: 1, count: 32)
        let secretCopy = Data(secret)
        let store = KeychainSecretStore()
        let secretId = UUID()
        try store.saveSecret(id: secretId, itemTypeCode: "ABCD", value: &secret)
        let retreivedSecret = try store.getSecret(id: secretId, itemTypeCode: "ABCD")
        XCTAssertEqual(secretCopy, retreivedSecret)
    }
    
    func testSaveAndRetrieveAsDifferentType() throws {
        let secretId : UUID = UUID()
        let store = KeychainSecretStore()
        var value = Data(repeating: 1, count: 32)
        try store.saveSecret(id: secretId, itemTypeCode: "ABCD", value: &value)
        do {
            let _ = try store.getSecret(id: secretId, itemTypeCode: "AAAA")
            XCTAssertTrue(false)
        } catch KeychainStoreError.itemNotFound {
            // We expect an exception for this case.
        }
    }
    
    func testD() throws {
        let store = KeychainSecretStore()
        let key = Random32BytesSecret(withStore: store)!
        let retreivedSecret = try store.getSecret(id: key.id, itemTypeCode: Random32BytesSecret.itemTypeCode)
        print(retreivedSecret.base64URLEncodedString())
        let sec = Secp256k1()
        let publicKey = try sec.createPublicKey(forSecret: key)
        print(publicKey.x.base64URLEncodedString())
        print(publicKey.y.base64URLEncodedString())
        XCTAssertEqual(publicKey.x.base64URLEncodedString(), "Ir5lqT2yDCXdWI8HgMj2erz9HVChFFv4Bd70oDqclvs")
        XCTAssertEqual(publicKey.y.base64URLEncodedString(), "_uSQb2NNO3MMnsS83ByMxayGbk3ODYxAlMx-_YOw5oc")
    }
}
