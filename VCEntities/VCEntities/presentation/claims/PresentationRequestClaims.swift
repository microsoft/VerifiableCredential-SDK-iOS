/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

public struct PresentationRequestClaims: OIDCClaims, Equatable {
    
    public let clientID: String
    
    public let issuer: String
    
    public let redirectURI: String
    
    public let responseType: String
    
    public let responseMode: String
    
    public let presentationDefinition: PresentationDefinition
    
    /// flag to determine if presentation request can go into issuance flow
    public let prompt: String?
    
    public let registration: RegistrationClaims?
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case issuer = "iss"
        case presentationDefinition = "presentation_definition"
        case redirectURI = "redirect_uri"
        case responseType = "response_type"
        case responseMode = "response_mode"
        case prompt, registration
    }
}

public typealias PresentationRequest = JwsToken<PresentationRequestClaims>
