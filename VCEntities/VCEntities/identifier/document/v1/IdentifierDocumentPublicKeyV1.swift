/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

struct IdentifierDocumentPublicKeyV1: Codable {
    let id: String
    let type: String
    let controller: String?
    let publicKeyJwk: ECPublicJwk
    let purposes: [String]
    
    init(id: String,
         type: String,
         controller: String?,
         publicKeyJwk: ECPublicJwk,
         purposes: [String]) {
        self.id = id
        self.type = type
        self.controller = controller
        self.publicKeyJwk = publicKeyJwk
        self.purposes = purposes
    }
    
    init(fromJwk key: ECPublicJwk) {
        self.init(id: key.keyId, type: "EcdsaSecp256k1VerificationKey2019", controller: nil, publicKeyJwk: key, purposes: ["authentication"])
    }
}
