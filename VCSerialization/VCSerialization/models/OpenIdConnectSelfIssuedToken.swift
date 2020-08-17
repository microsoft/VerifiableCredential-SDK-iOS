/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct OpenIdConnectSelfIssuedContents: JSONSerializable {
    let responseType: String
    let responseMode: String
    let clientID: String
    let redirectURI: String
    let scope: String
    let state: String
    let nonce: String
    let attestations: Attestations?
    let iss: String
    let registration: Registration
    let iat: Int
    let exp: Int
    let prompt: String

    enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case responseMode = "response_mode"
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
        case scope, state, nonce, attestations, iss, registration, iat, exp, prompt
    }
}

struct Registration: JSONSerializable {
    let clientName, clientPurpose: String
    let tosURI: String
    let logoURI: String

    enum CodingKeys: String, CodingKey {
        case clientName = "client_name"
        case clientPurpose = "client_purpose"
        case tosURI = "tos_uri"
        case logoURI = "logo_uri"
    }
}
