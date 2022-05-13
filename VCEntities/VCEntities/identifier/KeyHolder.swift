/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public class KeyHolder : VCCryptoSecret {
    
    private var data: Data
    
    public var key: Data {
        get {
            return data
        }
    }

    public let id: UUID
    
    public var accessGroup: String?

    public init(id: UUID, key: Data, accessGroup: String? = nil) {
        self.id = id
        self.data = key
        self.accessGroup = accessGroup
    }
    
    public func isValidKey() -> Bool {
        return true
    }
    
    public func migrateKey(fromAccessGroup currentAccessGroup: String?) throws {
        /* Do nothing */
    }
    
    deinit {
        data.withUnsafeMutableBytes { (keyPtr) in
            let keyBytes = keyPtr.bindMemory(to: UInt8.self)
            memset_s(keyBytes.baseAddress, keyBytes.count, 0, keyBytes.count)
            return
        }
    }
}
