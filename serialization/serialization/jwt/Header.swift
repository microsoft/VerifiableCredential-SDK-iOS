/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

struct Header: JSONSerializable {
    /// Type Header Parameter
    public var typ: String?
    /// Algorithm Header Parameter
    public internal(set) var alg: String?
    /// JSON Web Key Header Parameter
    public var jwk: String?
    /// Key ID Header Parameter
    public var kid: String?
}
