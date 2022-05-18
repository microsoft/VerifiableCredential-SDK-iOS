/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

public enum SecretStoringError: Error {
    case itemNotFound
    case invalidItemInStore
    case itemAlreadyInStore
    case invalidType
}

// public until Identifier Creation is implemented.
public protocol SecretStoring {
    
    func getSecret(id: UUID, itemTypeCode: String, accessGroup: String?) throws -> Data
    func saveSecret(id: UUID, itemTypeCode: String, accessGroup: String?, value: inout Data) throws
    func deleteSecret(id: UUID, itemTypeCode: String, accessGroup: String?) throws

}
