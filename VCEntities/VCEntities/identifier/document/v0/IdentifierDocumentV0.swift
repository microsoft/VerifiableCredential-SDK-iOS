/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

struct IdentifierDocumentV0: Codable {
    let publicKeys: [IdentifierDocumentPublicKeyV0]
    let serviceEndpoints: [IdentifierDocumentServiceEndpoint]?
    
    enum CodingKeys: String, CodingKey {
        case publicKeys = "public_keys"
        case serviceEndpoints = "service_endpoints"
    }
    
    init(fromJwks jwks: [ECPublicJwk], andServiceEndpoints endpoints: [IdentifierDocumentServiceEndpoint]) {
        var keys: [IdentifierDocumentPublicKeyV0] = []
        for jwk in jwks {
            keys.append(IdentifierDocumentPublicKeyV0(fromJwk: jwk))
        }
        self.publicKeys = keys
        self.serviceEndpoints = endpoints
    }
}
