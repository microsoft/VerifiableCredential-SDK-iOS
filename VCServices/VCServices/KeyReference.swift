/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public struct KeyReference : VCCryptoSecret {

    public var key: Data? {
        get {
            do {
                var data = try ops.getKey(withId: self.id)
                defer {
                    data.withUnsafeMutableBytes { (keyPtr) in
                        let keyBytes = keyPtr.bindMemory(to: UInt8.self)
                        memset_s(keyBytes.baseAddress, keyBytes.count, 0, keyBytes.count)
                        return
                    }
                }
                return data
            }
            catch {
                return nil
            }
        }
    }

    public let id: UUID
    
    public var accessGroup: String?
    
    private let ops: CryptoOperating

    public init(id: UUID, ops: CryptoOperating, accessGroup: String? = nil) {
        self.id = id
        self.ops = ops
        self.accessGroup = accessGroup
    }
    
    public func isValidKey() -> Bool
    {
        if let data = self.key {
            return !data.isEmpty
        }
        return false
    }
    
    public func migrateKey(fromAccessGroup currentAccessGroup: String?) throws {
        /* Do nothing */
    }
}
