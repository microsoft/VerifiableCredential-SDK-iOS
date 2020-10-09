/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct Identifier {
    public let longFormDid: String
    let didDocumentKeys: [KeyContainer]
    let updateKey: KeyContainer
    let recoveryKey: KeyContainer
    
    public init(longFormDid: String,
                didDocumentKeys: [KeyContainer],
                updateKey: KeyContainer,
                recoveryKey: KeyContainer) {
        self.longFormDid = longFormDid
        self.didDocumentKeys = didDocumentKeys
        self.updateKey = updateKey
        self.recoveryKey = recoveryKey
    }
}
