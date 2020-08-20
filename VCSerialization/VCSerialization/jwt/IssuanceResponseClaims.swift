/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct IssuanceResponseClaims: OidcClaims {
    
    let responseType: String = ""
    
    let responseMode: String = ""
    
    let clientID: String = ""
    
    let redirectURI: String = ""
    
    let scope: String = ""
    
    let iss: String = ""
    
    let publicKeyThumbprint: String = ""
    
    let audience = ""
    
    let publicKey: EllipticCurvePublicKey
    
    let contract: String = ""
    
    let jti: String
    
    let attestations: Attestations
    
    enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case responseMode = "response_mode"
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
        case publicKeyThumbprint = "sub"
        case audience = "aud"
        case publicKey = "sub_jwk"
        case scope, iss, contract, attestations, jti
    }
}