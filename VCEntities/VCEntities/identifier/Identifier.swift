/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct Identifier {
    public let longformId: String
    let didDocumentKeys: [KeyContainer]
    let updateKey: KeyContainer
    let recoveryKey: KeyContainer
}

struct KeyContainer {
    
    /// key reference to key in Secret Store
    let keyReference: VCCryptoSecret
    
    /// keyId to specify key in Identifier Document (must be less than 20 chars long)
    let keyId: String
    
    /// Always ES256K because we only support Secp256k1 keys
    let algorithm: String = "ES256K"
}
