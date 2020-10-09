/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct SuffixDescriptor: Codable {
    let patchDescriptorHash: String
    let recoveryCommitmentHash: String
    
    enum CodingKeys: String, CodingKey {
        case patchDescriptorHash = "delta_hash"
        case recoveryCommitmentHash = "recovery_commitment"
    }
}
