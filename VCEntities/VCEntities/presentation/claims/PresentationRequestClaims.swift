/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public struct PresentationRequestClaims: OIDCClaims, Equatable {
    
    public let clientID: String?
    
    public let issuer: String
    
    public let redirectURI: String?
    
    public let responseType: String
    
    public let responseMode: String
    
    public let presentationDefinition: PresentationDefinition
    
    public let state: String?
    
    public let nonce: String?
    
    public let scope: String
    
    /// flag to determine if presentation request can go into issuance flow
    public let prompt: String?
    
    public let registration: RegistrationClaims?
    
    public let idTokenHint: IssuerIdToken?
    
    public let iat: Double?
    
    public let exp: Double?
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case issuer = "iss"
        case presentationDefinition = "presentation_definition"
        case redirectURI = "redirect_uri"
        case responseType = "response_type"
        case responseMode = "response_mode"
        case idTokenHint = "id_token_hint"
        case state, nonce, prompt, registration, iat, exp, scope
    }
    
    init(clientID: String,
         issuer: String,
         redirectURI: String?,
         responseMode: String,
         responseType: String,
         presentationDefinition: PresentationDefinition,
         state: String?,
         nonce: String?,
         scope: String,
         prompt: String?,
         registration: RegistrationClaims?,
         idTokenHint: IssuerIdToken? = nil,
         iat: Double?,
         exp: Double?) {
        self.clientID = clientID
        self.issuer = issuer
        self.redirectURI = redirectURI
        self.responseMode = responseMode
        self.responseType = responseType
        self.presentationDefinition = presentationDefinition
        self.state = state
        self.nonce = nonce
        self.scope = scope
        self.prompt = prompt
        self.registration = registration
        self.idTokenHint = idTokenHint
        self.iat = iat
        self.exp = exp
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clientID = try values.decodeIfPresent(String.self, forKey: .clientID)
        issuer = try values.decode(String.self, forKey: .issuer)
        redirectURI = try values.decodeIfPresent(String.self, forKey: .redirectURI)
        responseMode = try values.decode(String.self, forKey: .responseMode)
        responseType = try values.decode(String.self, forKey: .responseType)
        presentationDefinition = try values.decode(PresentationDefinition.self, forKey: .presentationDefinition)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        nonce = try values.decodeIfPresent(String.self, forKey: .nonce)
        prompt = try values.decodeIfPresent(String.self, forKey: .prompt)
        scope = try values.decode(String.self, forKey: .scope)
        iat = try values.decodeIfPresent(Double.self, forKey: .iat)
        exp = try values.decodeIfPresent(Double.self, forKey: .exp)
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
        try container.encodeIfPresent(iat, forKey: .iat)
        try container.encodeIfPresent(exp, forKey: .exp)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(registration, forKey: .registration)
        try container.encodeIfPresent(idTokenHint?.raw, forKey: .idTokenHint)
    }
}

public typealias PresentationRequestToken = JwsToken<PresentationRequestClaims>
