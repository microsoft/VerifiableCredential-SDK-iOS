/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct AccessTokenDescriptor: Codable, Equatable {
    
    public let id: String?
    public let encrypted: Bool?
    public let claims: [ClaimDescriptor]?
    public let required: Bool?
    public let configuration: String?
    public let resourceId: String?
    public let oboScope: String?
}
