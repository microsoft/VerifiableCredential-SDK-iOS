/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

public struct PresentationRequestClaims: OIDCClaims {
    
    public let clientID: String?
    
    public let issuer: String?
    
    public let redirectURI: String?
    
    public let responseType: String?
    
    public let responseMode: String?
    
    public let presentationDefinition: PresentationDefinition?
    
    public let state: String?
    
    public let nonce: String?
    
    /// flag to determine if presentation request can go into issuance flow
    public let prompt: String?
    
    public let registration: RegistrationClaims?
    
    public let idTokenHint: IssuerIdToken?
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case issuer = "iss"
        case presentationDefinition = "presentation_definition"
        case redirectURI = "redirect_uri"
        case responseType = "response_type"
        case responseMode = "response_mode"
        case idTokenHint = "id_token_hint"
        case state, nonce, prompt, registration
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clientID = try values.decodeIfPresent(String.self, forKey: .clientID)
        issuer = try values.decodeIfPresent(String.self, forKey: .issuer)
        redirectURI = try values.decodeIfPresent(String.self, forKey: .redirectURI)
        responseMode = try values.decodeIfPresent(String.self, forKey: .responseMode)
        responseType = try values.decodeIfPresent(String.self, forKey: .responseType)
        presentationDefinition = try values.decodeIfPresent(PresentationDefinition.self, forKey: .presentationDefinition)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        nonce = try values.decodeIfPresent(String.self, forKey: .nonce)
        prompt = try values.decodeIfPresent(String.self, forKey: .prompt)
        registration = try values.decodeIfPresent(RegistrationClaims.self, forKey: .registration)
        let idTokenHintSerialized = try values.decodeIfPresent(String.self, forKey: .idTokenHint)
        if let idToken = idTokenHintSerialized {
            idTokenHint = IssuerIdToken(from: idToken)
        } else {
            idTokenHint = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(clientID, forKey: .clientID)
        try container.encodeIfPresent(issuer, forKey: .issuer)
        try container.encodeIfPresent(redirectURI, forKey: .redirectURI)
        try container.encodeIfPresent(responseMode, forKey: .responseMode)
        try container.encodeIfPresent(responseType, forKey: .responseType)
        try container.encodeIfPresent(presentationDefinition, forKey: .presentationDefinition)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(nonce, forKey: .nonce)
        try container.encodeIfPresent(prompt, forKey: .prompt)
        try container.encodeIfPresent(registration, forKey: .registration)
        try container.encodeIfPresent(idTokenHint?.raw, forKey: .idTokenHint)
    }
}

public typealias PresentationRequest = JwsToken<PresentationRequestClaims>
