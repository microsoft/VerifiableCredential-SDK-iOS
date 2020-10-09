/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

struct IdentifierDocumentPublicKey: Codable {
    let id: String
    let type: String
    let controller: String?
    let jwk: ECPublicJwk
    let purpose: [String]
    
    init(id: String,
         type: String,
         controller: String?,
         jwk: ECPublicJwk,
         purpose: [String]) {
        self.id = id
        self.type = type
        self.controller = controller
        self.jwk = jwk
        self.purpose = purpose
    }
    
    init(fromJwk key: ECPublicJwk) {
        self.init(id: key.keyId, type: "EcdsaSecp256k1VerificationKey2019", controller: nil, jwk: key, purpose: ["auth", "general"])
    }
}
