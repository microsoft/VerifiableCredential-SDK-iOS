/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct PresentationRequestClaims: OidcClaims {
    let responseType: String = ""
    
    let responseMode: String = ""
    
    let clientID: String = ""
    
    let redirectURI: String = ""
    
    enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case responseMode = "response_mode"
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
    }
}
