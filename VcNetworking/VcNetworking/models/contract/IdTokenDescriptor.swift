/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

public struct IdTokenDescriptor: Codable, Equatable {
    
    public let encrypted: Bool = false
    public let claims: [ClaimDescriptor] = []
    public let idTokenRequired: Bool = false
    public let configuration: String = ""
    public let clientID: String = ""
    public let redirectURI: String = ""

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case idTokenRequired = "required"
        case configuration
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
    }
}
