/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

/// OIDC Claims that represent a Verifiable Credential Presentation Request.
public struct PresentationRequestClaims: OIDCClaims, Equatable {
    
    public let jti: String?
    
    public let clientID: String?
    
    public let redirectURI: String?
    
    public let responseType: String?
    
    public let responseMode: String?
    
    public let claims: RequestedClaims?
    
    public let state: String?
    
    public let nonce: String?
    
    public let scope: String?
    
    /// flag to determine if presentation request can go into issuance flow
    public let prompt: String?
    
    public let registration: RegistrationClaims?
    
    public let idTokenHint: IssuerIdToken?
    
    public let iat: Double?
    
    public let exp: Double?
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
        case responseType = "response_type"
        case responseMode = "response_mode"
        case idTokenHint = "id_token_hint"
        case state, nonce, prompt, registration, iat, exp, scope, claims, jti
    }
    
    public init(jti: String?,
                clientID: String?,
                redirectURI: String?,
                responseType: String?,
                responseMode: String?,
                claims: RequestedClaims?,
                state: String?,
                nonce: String?,
                scope: String?,
                prompt: String?,
                registration: RegistrationClaims?,
                idTokenHint: IssuerIdToken? = nil,
                iat: Double?,
                exp: Double?) {
        self.jti = jti
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.responseType = responseType
        self.responseMode = responseMode
        self.claims = claims
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
        jti = try values.decodeIfPresent(String.self, forKey: .jti)
        clientID = try values.decodeIfPresent(String.self, forKey: .clientID)
        redirectURI = try values.decodeIfPresent(String.self, forKey: .redirectURI)
        responseMode = try values.decodeIfPresent(String.self, forKey: .responseMode)
        responseType = try values.decodeIfPresent(String.self, forKey: .responseType)
        claims = try values.decodeIfPresent(RequestedClaims.self, forKey: .claims)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        nonce = try values.decodeIfPresent(String.self, forKey: .nonce)
        prompt = try values.decodeIfPresent(String.self, forKey: .prompt)
        scope = try values.decodeIfPresent(String.self, forKey: .scope)
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
        try container.encodeIfPresent(jti, forKey: .jti)
        try container.encodeIfPresent(clientID, forKey: .clientID)
        try container.encodeIfPresent(redirectURI, forKey: .redirectURI)
        try container.encodeIfPresent(responseMode, forKey: .responseMode)
        try container.encodeIfPresent(responseType, forKey: .responseType)
        try container.encodeIfPresent(claims, forKey: .claims)
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

/// JWT representation of a Presentation Request.
public typealias PresentationRequestToken = JwsToken<PresentationRequestClaims>
