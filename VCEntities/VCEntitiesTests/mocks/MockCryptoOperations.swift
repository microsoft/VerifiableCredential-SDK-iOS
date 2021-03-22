/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto
import VCToken

@testable import VCEntities

struct MockCryptoOperations: CryptoOperating {
    
    static var generateKeyCallCount = 0
    let cryptoOperations: CryptoOperating
    
    init(secretStore: SecretStoring) {
        self.cryptoOperations = CryptoOperations(secretStore: secretStore)
    }
    
    func generateKey() throws -> VCCryptoSecret {
        MockCryptoOperations.generateKeyCallCount += 1
        return try self.cryptoOperations.generateKey()
    }
    
    func retrieveKeyFromStorage(withId id: UUID) throws -> VCCryptoSecret {
        return KeyId(id: id)
    }
}
