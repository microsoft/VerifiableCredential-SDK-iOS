/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public struct PresentationResponseClaims: OIDCClaims {
    
    public let issuer: String = VCEntitiesConstants.SELF_ISSUED
        
    public let publicKeyThumbprint: String
    
    public let audience: String
    
    public let did: String
    
    public let publicJwk: ECPublicJwk?
    
    public let jti: String
    
    public let presentationSubmission: PresentationSubmission?
    
    public let attestations: AttestationResponseDescriptor?
    
    public let state: String?
    
    public let nonce: String?
    
    public let iat: Double?
    
    public let nbf: Double?
    
    public let exp: Double?
    
    public init(publicKeyThumbprint: String = "",
                audience: String = "",
                did: String = "",
                publicJwk: ECPublicJwk? = nil,
                jti: String = "",
                presentationSubmission: PresentationSubmission? = nil,
                attestations: AttestationResponseDescriptor? = nil,
                state: String?,
                nonce: String?,
                iat: Double? = nil,
                nbf: Double? = nil,
                exp: Double? = nil) {
        self.publicKeyThumbprint = publicKeyThumbprint
        self.audience = audience
        self.did = did
        self.publicJwk = publicJwk
        self.jti = jti
        self.attestations = attestations
        self.state = state
        self.nonce = nonce
        self.iat = iat
        self.nbf = nbf
        self.exp = exp
        self.presentationSubmission = presentationSubmission
    }
    
    enum CodingKeys: String, CodingKey {
        case issuer = "iss"
        case publicKeyThumbprint = "sub"
        case presentationSubmission = "presentation_submission"
        case audience = "aud"
        case publicJwk = "sub_jwk"
        case attestations, jti, did, iat, exp, state, nonce, nbf
    }
}

public typealias PresentationResponse = JwsToken<PresentationResponseClaims>
