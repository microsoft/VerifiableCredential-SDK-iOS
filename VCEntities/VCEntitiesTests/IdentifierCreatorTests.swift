/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import XCTest
import VCCrypto

@testable import VCEntities

class IdentifierCreatorTests: XCTestCase {

    func testLongform() throws {
        let cryptoOp = CryptoOperations(secretStore: SecretStoreMock())
        let creator = IdentifierCreator(cryptoOperations: cryptoOp)
        print(try creator.create())
    }
}
