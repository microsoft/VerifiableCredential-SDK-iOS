/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct KeyContainer {
    
    /// key reference to key in Secret Store
    let keyReference: VCCryptoSecret
    
    /// keyId to specify key in Identifier Document (must be less than 20 chars long)
    let keyId: String
    
    /// Always ES256K because we only support Secp256k1 keys
    let algorithm: String = "ES256K"
    
    public init(keyReference: VCCryptoSecret,
                keyId: String) {
        self.keyReference = keyReference
        self.keyId = keyId
    }
    
    public func getId() -> UUID {
        return keyReference.id
    }
}
