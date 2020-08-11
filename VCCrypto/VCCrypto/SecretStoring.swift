/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

protocol SecretStoring {
    func getSecret(id: UUID, type: String) throws -> Data
    func saveSecret(id: UUID, type: String, value: inout Data) throws
}
