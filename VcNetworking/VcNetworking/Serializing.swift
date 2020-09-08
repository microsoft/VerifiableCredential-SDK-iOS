/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

public protocol Serializing {
    func deserialize<T: Codable>(_: T.Type, data: Data) throws -> T
    func serialize<T: Codable>(object: T) throws -> Data
}
