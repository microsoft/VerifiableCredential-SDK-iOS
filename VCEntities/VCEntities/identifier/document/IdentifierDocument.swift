/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt
import VCCrypto

struct IdentifierDocument: Codable {
    let publicKeys: [IdentifierDocumentPublicKey]
    let serviceEndpoints: [IdentifierDocumentServiceEndpoint]?
    
    enum CodingKeys: String, CodingKey {
        case publicKeys = "public_keys"
        case serviceEndpoints = "service_endpoints"
    }
    
    init(fromJwks jwks: [ECPublicJwk], andServiceEndpoints endpoints: [IdentifierDocumentServiceEndpoint]) {
        var keys: [IdentifierDocumentPublicKey] = []
        for jwk in jwks {
            keys.append(IdentifierDocumentPublicKey(fromJwk: jwk))
        }
        self.publicKeys = keys
        self.serviceEndpoints = endpoints
    }
}
