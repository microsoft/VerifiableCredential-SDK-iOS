/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt

public struct IssuanceResponseClaims: OIDCClaims {
    
    public let responseType: String
    
    public let responseMode: String
    
    public let clientID: String
    
    public let redirectURI: String
    
    public let publicKeyThumbprint: String
    
    public let audience: String
    
    public let did: String
    
    public let publicJwk: ECPublicJwk
    
    public let contract: String
    
    public let jti: String
    
    public let attestations: AttestationResponseDescriptor?
    
    public init(responseType: String = "",
                responseMode: String = "",
                clientID: String = "",
                redirectURI: String = "",
                publicKeyThumbprint: String = "",
                audience: String = "",
                did: String = "",
                publicJwk: ECPublicJwk = ECPublicJwk(),
                contract: String = "",
                jti: String = "",
                attestations: AttestationResponseDescriptor? = nil) {
        self.responseType = responseType
        self.responseMode = responseMode
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.publicKeyThumbprint = publicKeyThumbprint
        self.audience = audience
        self.did = did
        self.publicJwk = publicJwk
        self.contract = contract
        self.jti = jti
        self.attestations = attestations
    }
    
    enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case responseMode = "response_mode"
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
        case publicKeyThumbprint = "sub"
        case audience = "aud"
        case publicJwk = "sub_jwk"
        case contract, attestations, jti, did
    }
}
