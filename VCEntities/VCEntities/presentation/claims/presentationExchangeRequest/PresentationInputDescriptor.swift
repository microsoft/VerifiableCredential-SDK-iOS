/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct PresentationInputDescriptor: Codable, Equatable {
    
    public let id: String
    
    public let schema: SchemaDescriptor
    
    public let issuanceMetadata: [IssuanceMetadata]
    
    enum CodingKeys: String, CodingKey {
        case issuanceMetadata = "issuance"
        case id, schema
    }
}
