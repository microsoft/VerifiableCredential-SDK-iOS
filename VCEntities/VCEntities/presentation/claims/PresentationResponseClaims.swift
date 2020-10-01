/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

public struct PresentationResponseClaims: OIDCClaims {
    
    public let issuer: String = "https://self-issued.me"
        
    public let publicKeyThumbprint: String
    
    public let audience: String
    
    public let did: String
    
    public let publicJwk: ECPublicJwk?
    
    public let contract: String
    
    public let jti: String
    
    public let presentationSubmission: PresentationSubmission?
    
    public let attestations: AttestationResponseDescriptor?
    
    public let iat: Double?
    
    public let exp: Double?
    
    public init(publicKeyThumbprint: String = "",
                audience: String = "",
                did: String = "",
                publicJwk: ECPublicJwk? = nil,
                contract: String = "",
                jti: String = "",
                attestations: AttestationResponseDescriptor? = nil,
                presentationSubmission: PresentationSubmission? = nil,
                iat: Double? = nil,
                exp: Double? = nil) {
        self.publicKeyThumbprint = publicKeyThumbprint
        self.audience = audience
        self.did = did
        self.publicJwk = publicJwk
        self.contract = contract
        self.jti = jti
        self.attestations = attestations
        self.iat = iat
        self.exp = exp
        self.presentationSubmission = presentationSubmission
    }
    
    enum CodingKeys: String, CodingKey {
        case issuer = "iss"
        case publicKeyThumbprint = "sub"
        case presentationSubmission = "presentation_submission"
        case audience = "aud"
        case publicJwk = "sub_jwk"
        case contract, attestations, jti, did, iat, exp
    }
}

public typealias PresentationResponse = JwsToken<PresentationResponseClaims>
