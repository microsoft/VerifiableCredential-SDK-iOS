/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

public struct PresentationRequestClaims: OIDCClaims {
    
    public let clientID: String
    
    public let issuer: String
    
    public let redirectURI: String
    
    public let responseType: String
    
    public let responseMode: String
    
    public let presentationDefinition: PresentationDefinition
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case issuer = "iss"
        case presentationDefinition = "presentation_definition"
        case redirectURI = "redirect_uri"
        case responseType = "response_type"
        case responseMode = "response_mode"
    }
}

public typealias PresentationRequest = JwsToken<PresentationRequestClaims>
