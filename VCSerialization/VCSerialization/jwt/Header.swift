/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct Header: Codable {
    public var type: String?
    public var algorithm: String?
    public var jsonWebKey: String?
    public var keyId: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "typ"
        case algorithm = "alg"
        case jsonWebKey = "jwk"
        case keyId = "kid"
    }
}
