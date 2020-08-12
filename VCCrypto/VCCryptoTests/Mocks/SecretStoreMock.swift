/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import Foundation
@testable import VCCrypto
internal class SecretStoreMock: SecretStoring {
    
    private var memoryStore = [UUID: Data]()
    
    func getSecret(id: UUID, itemTypeCode: String) throws -> Data {
        return memoryStore[id]!
    }
    
    func saveSecret(id: UUID, itemTypeCode: String, value: inout Data) throws {
        memoryStore[id] = value
    }
}
