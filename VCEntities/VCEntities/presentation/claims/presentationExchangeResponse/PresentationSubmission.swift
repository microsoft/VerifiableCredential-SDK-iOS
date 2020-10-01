/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct PresentationSubmission: Codable {
    public let submissionDescriptors: [SubmissionDescriptor]
    
    enum CodingKeys: String, CodingKey {
        case submissionDescriptors = "descriptor_map"
    }
}
