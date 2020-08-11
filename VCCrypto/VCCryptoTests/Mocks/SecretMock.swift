/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/


import Foundation
@testable import VCCrypto

final class SecretMock : Secret {
    static var typeName: String = "MOCK"
    var id: UUID
    private var value: Data
    
    init(id: UUID, withData value: Data) {
        self.value = value
        self.id = id
    }
    
    func withUnsafeBytes(f: (UnsafeRawBufferPointer) throws -> Void) throws {
        try value.withUnsafeBytes { (valuePtr) in
            try f(valuePtr)
        }
    }
}
