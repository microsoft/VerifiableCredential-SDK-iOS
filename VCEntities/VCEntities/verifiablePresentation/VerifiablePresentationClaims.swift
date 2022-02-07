/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public struct VerifiablePresentationClaims: OIDCClaims {
    let vpId: String
    
    let verifiablePresentation: VerifiablePresentationDescriptor
    
    let issuerOfVp: String
    
    let audience: String
    
    let iat: Double
    
    let nbf: Double
    
    let exp: Double
    
    let nonce: String?
    
    enum CodingKeys: String, CodingKey {
        case issuerOfVp = "iss"
        case audience = "aud"
        case vpId = "jti"
        case verifiablePresentation = "vp"
        case iat, exp, nonce, nbf
    }
}

public typealias VerifiablePresentation = JwsToken<VerifiablePresentationClaims>
