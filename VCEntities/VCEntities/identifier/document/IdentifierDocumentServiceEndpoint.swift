/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct IdentifierDocumentServiceEndpoint: Codable, Equatable {
    let id: String
    public let type: String
    public let endpoint: String
    
    public init(id: String, type: String, endpoint: String) {
        self.id = id
        self.type = type
        self.endpoint = endpoint
    }
}
