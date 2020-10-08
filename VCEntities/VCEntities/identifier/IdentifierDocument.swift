/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

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

struct IdentifierDocumentServiceEndpoint: Codable {
    let id: String
    let type: String
    let endpoint: String
}

struct IdentifierDocumentPatch: Codable {
    let action: String
    let document: IdentifierDocument
}

struct IdentifierDocumentDeltaDescriptor: Codable {
    let updateCommitment: String
    let patches: [IdentifierDocumentPatch]
    
    enum CodingKeys: String, CodingKey {
        case updateCommitment = "update_commitment"
        case patches
    }
}

struct RegistrationPayload: Codable {
    let suffixData: String
    let patchData: String
    
    enum CodingKeys: String, CodingKey {
        case suffixData = "suffix_data"
        case patchData = "delta"
    }
}

struct SuffixDescriptor: Codable {
    let patchDescriptorHash: String
    let recoveryCommitmentHash: String
    
    enum CodingKeys: String, CodingKey {
        case patchDescriptorHash = "delta_hash"
        case recoveryCommitmentHash = "recovery_commitment"
    }
}

struct Identifier: Codable {
    let longformId: String
}
