/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

struct VerifiablePresentationClaims: OIDCClaims {
    let vpId: String
    
    let purpose: String
    
    let verifiablePresentation: VerifiablePresentationDescriptor
    
    let issuerOfVp: String
    
    let audience: String
    
    let iat: Double
    
    let exp: Double
    
    enum CodingKeys: String, CodingKey {
        case issuerOfVp = "iss"
        case audience = "aud"
        case vpId = "jti"
        case verifiablePresentation = "vp"
        case iat, exp, purpose
    }
}

typealias VerifiablePresentation = JwsToken<VerifiablePresentationClaims>
