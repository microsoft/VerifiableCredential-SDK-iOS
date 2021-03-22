/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

// public until Identifier Creation is implemented.
public protocol SecretStoring {
    
    func getSecret(id: UUID, itemTypeCode: String) throws -> Data
    func saveSecret(id: UUID, itemTypeCode: String, value: inout Data) throws
}
