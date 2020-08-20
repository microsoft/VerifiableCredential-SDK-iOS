/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

protocol PublicKey: Codable {
    var keyType: String { get }
    var keyId: String { get }
    var use: String { get }
    var keyOperations: [String] { get }
    var algorithm: String { get }
}

