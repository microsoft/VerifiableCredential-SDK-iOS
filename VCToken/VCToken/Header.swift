/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct Header: Codable {
    public let type: String?
    public let algorithm: String?
    public let jsonWebKey: ECPublicJwk?
    public let keyId: String?
    
    public init(type: String? = nil,
                algorithm: String? = nil,
                jsonWebKey: ECPublicJwk? = nil,
                keyId: String? = nil) {
        self.type = type
        self.algorithm = algorithm
        self.jsonWebKey = jsonWebKey
        self.keyId = keyId
    }

    public enum CodingKeys: String, CodingKey {
        case type = "typ"
        case algorithm = "alg"
        case jsonWebKey = "jwk"
        case keyId = "kid"
    }

    // Note: implementing decode and encode to work around a compiler issue causing a EXC_BAD_ACCESS.
    // See: https://bugs.swift.org/browse/SR-7090
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        algorithm = try values.decodeIfPresent(String.self, forKey: .algorithm)
        jsonWebKey = try values.decodeIfPresent(ECPublicJwk.self, forKey: .jsonWebKey)
        keyId = try values.decodeIfPresent(String.self, forKey: .keyId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(algorithm, forKey: .algorithm)
        try container.encodeIfPresent(jsonWebKey, forKey: .jsonWebKey)
        try container.encodeIfPresent(keyId, forKey: .keyId)
    }
}
