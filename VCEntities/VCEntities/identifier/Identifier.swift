/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct Identifier {
    public let longFormDid: String
    public let didDocumentKeys: [KeyContainer]
    public let updateKey: KeyContainer
    public let recoveryKey: KeyContainer
    public let alias: String
    
    public init(longFormDid: String,
                didDocumentKeys: [KeyContainer],
                updateKey: KeyContainer,
                recoveryKey: KeyContainer,
                alias: String) {
        self.longFormDid = longFormDid
        self.didDocumentKeys = didDocumentKeys
        self.updateKey = updateKey
        self.recoveryKey = recoveryKey
        self.alias = alias
    }
}
