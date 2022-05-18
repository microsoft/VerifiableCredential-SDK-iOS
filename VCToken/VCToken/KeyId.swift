/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct KeyId: VCCryptoSecret {
    
    public let id: UUID
    
    public let accessGroup: String? = nil
    
    public init(id: UUID) {
        self.id = id
    }
    
    public func isValidKey() -> Bool {
        return true
    }
    
    public func migrateKey(fromAccessGroup oldAccessGroup: String?) throws { }

    public func withUnsafeBytes(_ body: (UnsafeRawBufferPointer) throws -> Void) throws { }
}
