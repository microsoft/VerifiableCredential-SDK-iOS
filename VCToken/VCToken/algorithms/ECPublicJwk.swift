/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

public protocol PublicJwk: Codable, Equatable {
    var keyType: String { get }
    var keyId: String? { get }
    var use: String? { get }
    var keyOperations: [String]? { get }
    var algorithm: String? { get }
    var curve: String { get }
    var x: String { get }
    var y: String { get }
}

public struct ECPublicJwk: PublicJwk {
    public let keyType: String
    public let keyId: String?
    public let use: String?
    public let keyOperations: [String]?
    public let algorithm: String?
    public let curve: String
    public let x: String
    public let y: String
    
    enum CodingKeys: String, CodingKey {
        case keyType = "kty"
        case keyId = "kid"
        case keyOperations = "key_ops"
        case algorithm = "alg"
        case curve = "crv"
        case use, x, y
    }
    
    public init(x: String, y: String, keyId: String) {
        self.keyType = "EC"
        self.keyId = keyId
        self.use = "sig"
        self.keyOperations = ["verify"]
        self.algorithm = "ES256K"
        self.curve = "secp256k1"
        self.x = x
        self.y = y
    }
    
    public init(withPublicKey key: Secp256k1PublicKey, withKeyId kid: String) {
        let x = key.x.base64URLEncodedString()
        let y = key.y.base64URLEncodedString()
        self.init(x: x, y: y, keyId: kid)
    }
    
    func getMinimumAlphabeticJwk() -> String {
        return "{\"crv\":\"\(self.curve)\",\"kty\":\"\(self.keyType)\",\"x\":\"\(self.x)\",\"y\":\"\(self.y)\"}"
    }
    
    public func getThumbprint() throws -> String {
        
        let hashAlgorithm = Sha256()
        
        guard let encodedJwk = self.getMinimumAlphabeticJwk().data(using: .utf8) else {
            throw VCTokenError.unableToParseString
        }
        
        let hash = hashAlgorithm.hash(data: encodedJwk)
        return hash.base64URLEncodedString()
    }
}
