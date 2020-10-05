/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct PresentationDefinition: Codable, Equatable {
    
    public let inputDescriptors: [PresentationInputDescriptor]
    
    enum CodingKeys: String, CodingKey {
        case inputDescriptors = "input_descriptors"
    }
}
