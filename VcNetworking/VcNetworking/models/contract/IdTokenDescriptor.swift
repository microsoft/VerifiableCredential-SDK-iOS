/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct IdTokenDescriptor: Codable {
    let encrypted: Bool?
    let claims: [ClaimDescriptor]
    let idTokenRequired: Bool
    let configuration: String
    let clientID: String?
    let redirectURI: String?

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case idTokenRequired = "required"
        case configuration
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
    }
}
