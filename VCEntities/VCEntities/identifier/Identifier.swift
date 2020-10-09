/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct Identifier {
    public let longformId: String
    let didDocumentKeys: [VCCryptoSecret]
    let updateKey: VCCryptoSecret
    let recoveryKey: VCCryptoSecret
}
