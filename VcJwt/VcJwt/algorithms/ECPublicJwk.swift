/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcCrypto

public struct ECPublicJwk: Codable {
    var keyType: String = ""
    var keyId: String
    var use: String = ""
    var keyOperations: [String] = []
    var algorithm: String = ""
    var curve: String = ""
    var x: String
    var y: String
    
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
        self.algorithm = "ES256k"
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
            throw VcJwtError.unableToParseString
        }
        print(String(data: encodedJwk, encoding: .utf8)!)
        
        let hash = hashAlgorithm.hash(data: encodedJwk)
        // print(String(data: hash, encoding: .utf8)!)
        return hash.base64URLEncodedString()
    }
}
