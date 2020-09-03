/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct Header: Codable {
    public let type: String?
    public let algorithm: String?
    public let jsonWebKey: String?
    public let keyId: String?
    
    public init(type: String? = nil, algorithm: String? = nil, jsonWebKey: String? = nil, keyId: String? = nil) {
        self.type = type
        self.algorithm = algorithm
        self.jsonWebKey = jsonWebKey
        self.keyId = keyId
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "typ"
        case algorithm = "alg"
        case jsonWebKey = "jwk"
        case keyId = "kid"
    }
}
