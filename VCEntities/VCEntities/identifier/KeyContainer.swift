/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct KeyContainer {
    
    /// key reference to key in Secret Store
    let keyReference: VCCryptoSecret
    
    /// Always ES256K because we only support Secp256k1 keys
    let algorithm: String = "ES256K"
    
    /// keyId to specify key in Identifier Document (must be less than 20 chars long)
    public let keyId: String
    
    public init(keyReference: VCCryptoSecret,
                keyId: String) {
        self.keyReference = keyReference
        self.keyId = keyId
    }
    
    public func getId() -> UUID {
        return keyReference.id
    }
    
    public func isValidKey() -> Bool {
        return keyReference.isValidKey()
    }
    
    /// Migrate key from old access group to new one set in sdk config.
    public func migrateKey(fromAccessGroup currentAccessGroup: String?) throws {
        try keyReference.migrateKey(fromAccessGroup: currentAccessGroup)
    }

    public func persist(in secretStore:SecretStoring) throws {
        try secretStore.save(secret: self.keyReference)
    }
}
