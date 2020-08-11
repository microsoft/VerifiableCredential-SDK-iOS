/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

final class Random32BytesSecret: Secret {
    static var typeName: String = "r32B"
    var id: UUID
    private let store: SecretStoring
    
    init?(withStore store: SecretStoring) {
        self.store = store
        
        var value = Data(count: 32)
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        let result = value.withUnsafeMutableBytes { (secretPtr) in
            SecRandomCopyBytes(kSecRandomDefault, secretPtr.count, secretPtr.baseAddress!)
        }
        
        guard result == errSecSuccess else { return nil }
        id = UUID()
        do {
            try self.store.saveSecret(id: id, type: Random32BytesSecret.typeName, value: &value)
        } catch {
            return nil
        }
    }
    
    func withUnsafeBytes(f: (UnsafeRawBufferPointer) throws -> Void) throws {
        var value = try self.store.getSecret(id: id, type: Random32BytesSecret.typeName)
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        try value.withUnsafeBytes { (valuePtr) in
            try f(valuePtr)
        }
    }
}
