/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/**
 * Contents of the Presentation Definition from the Presentation Exchange protocol.
 *
 * @see [Presentation Exchange Spec](https://identity.foundation/presentation-exchange/#presentation-definition)
 */
public struct PresentationDefinition: Codable, Equatable {
    
    public let inputDescriptors: [PresentationInputDescriptor]?
    
    public let issuance: [String]?
    
    public let constraints: [String]?
    
    enum CodingKeys: String, CodingKey {
        case inputDescriptors = "input_descriptors"
        case issuance, constraints
    }
}
