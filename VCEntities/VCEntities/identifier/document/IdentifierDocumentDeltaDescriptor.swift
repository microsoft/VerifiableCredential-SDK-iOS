/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct IdentifierDocumentDeltaDescriptor: Codable {
    let updateCommitment: String
    let patches: [IdentifierDocumentPatch]
    
    enum CodingKeys: String, CodingKey {
        case updateCommitment = "update_commitment"
        case patches
    }
}
