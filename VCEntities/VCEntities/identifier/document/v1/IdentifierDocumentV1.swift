/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

struct IdentifierDocumentV1: Codable {
    let publicKeys: [IdentifierDocumentPublicKeyV1]
    let services: [IdentifierDocumentServiceEndpoint]?
    
    init(fromJwks jwks: [ECPublicJwk], andServiceEndpoints services: [IdentifierDocumentServiceEndpoint]) {
        var keys: [IdentifierDocumentPublicKeyV1] = []
        for jwk in jwks {
            keys.append(IdentifierDocumentPublicKeyV1(fromJwk: jwk))
        }
        self.publicKeys = keys
        self.services = services
    }
}
