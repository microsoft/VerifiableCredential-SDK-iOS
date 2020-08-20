/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct PresentationRequestClaims: OidcClaims {
    let responseType: String = ""
    
    let responseMode: String = ""
    
    let clientID: String = ""
    
    let redirectURI: String = ""
    
    let scope: String = ""
    
    let state: String = ""
    
    let nonce: String = ""
    
    let iss: String = ""
    
    let registration: Registration = Registration()
    
    let prompt: String = ""
    
    enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case responseMode = "response_mode"
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
        case scope, state, nonce, iss, registration, prompt
    }
}
