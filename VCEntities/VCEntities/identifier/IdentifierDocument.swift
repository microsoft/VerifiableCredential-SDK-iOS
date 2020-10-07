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
}

struct IdentifierDocumentPublicKey: Codable {
    let id: String
    let type: String
    let controller: String?
    let jwk: ECPublicJwk
    let purpose: [String]
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

struct IdentifierDocumentPatchDescriptor: Codable {
    let nextUpdateCommitmentHash: String
    let patches: [IdentifierDocumentPatch]
    
    enum CodingKeys: String, CodingKey {
        case nextUpdateCommitmentHash = "update_commitment"
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
