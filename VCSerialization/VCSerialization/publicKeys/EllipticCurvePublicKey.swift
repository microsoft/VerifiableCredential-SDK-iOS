/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct EllipticCurvePublicKey: Codable {
    var keyType: String
    var keyId: String
    var use: String
    var keyOperations: [String]
    var algorithm: String
    var curve: String
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
}
