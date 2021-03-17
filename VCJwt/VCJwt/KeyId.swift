/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct KeyId: VCCryptoSecret {
    public let id: UUID
    
    public init(id: UUID) {
        self.id = id
    }
}
