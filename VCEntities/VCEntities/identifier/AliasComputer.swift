/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct AliasComputer {
    
    let hashingAlg = Sha256()
    
    public init() {}
    
    // TODO: temporarily computing alias by hashing id of VC and rp DID until
    // deterministic key generation is implemented
    public func compute(forId id: String, andRelyingParty rp: String) -> String {
        let message = (id + rp).data(using: .ascii)
        let hashedMessage = hashingAlg.hash(data: message!)
        let base64EncodedAlias = hashedMessage.base64EncodedString().prefix(10)
        return String(base64EncodedAlias)
    }
}
