/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct IdentifierDocumentDeltaDescriptorV1: Codable {
    let updateCommitment: String
    let patches: [IdentifierDocumentPatchV1]
}
