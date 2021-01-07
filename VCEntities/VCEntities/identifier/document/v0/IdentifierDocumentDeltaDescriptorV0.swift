/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct IdentifierDocumentDeltaDescriptorV0: Codable {
    let updateCommitment: String
    let patches: [IdentifierDocumentPatchV0]
    
    enum CodingKeys: String, CodingKey {
        case updateCommitment = "update_commitment"
        case patches
    }
}
