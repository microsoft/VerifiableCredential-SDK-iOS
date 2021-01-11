/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

struct IdentifierDocumentPublicKeyV0: Codable {
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
        self.init(id: key.keyId, type: VCEntitiesConstants.SUPPORTED_PUBLICKEY_TYPE, controller: nil, jwk: key, purpose: [VCEntitiesConstants.PUBLICKEY_AUTHENTICATION_PURPOSE_V0, VCEntitiesConstants.PUBLICKEY_GENERAL_PURPOSE_V0])
    }
}
