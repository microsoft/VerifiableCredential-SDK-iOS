/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCCrypto
import VCJwt

@testable import VCEntities

class IdentifierCreatorTests: XCTestCase {

    func testLongform() throws {
        let cryptoOp = CryptoOperations(secretStore: SecretStoreMock())
        let creator = IdentifierCreator(cryptoOperations: cryptoOp)
        let keyRef = try cryptoOp.generateKey()
        let key = try Secp256k1().createPublicKey(forSecret: keyRef)
        let jwk = ECPublicJwk(withPublicKey: key, withKeyId: "sydney")
        print(try creator.createIonLongForm(recoveryKey: jwk, updateKey: jwk, didDocumentKeys: [jwk], serviceEndpoints: []))
    }
}
