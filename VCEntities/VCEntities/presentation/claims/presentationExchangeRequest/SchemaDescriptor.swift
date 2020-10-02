/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct SchemaDescriptor: Codable, Equatable {
    public let uri: [String]?
    
    public let name: String?
    
    public let purpose: String?
}
