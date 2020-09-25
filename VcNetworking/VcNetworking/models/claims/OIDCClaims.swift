/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

protocol OIDCClaims: Claims {
    var responseType: String { get }
    var responseMode: String { get }
    var clientID: String { get }
    var redirectURI: String { get }
    var scope: String { get }
    var state: String { get }
    var nonce: String { get }
    var issuer: String { get }
    var registration: RegistrationClaims { get }
    var prompt: String { get }
}

extension OIDCClaims {
    var responseType: String {
        return ""
    }
    
    var responseMode: String {
        return ""
    }
    
    var clientID: String {
        return ""
    }
    
    var redirectURI: String {
        return ""
    }
    
    var scope: String {
        return ""
    }

    var state: String {
        return ""
    }
    
    var nonce: String {
        return ""
    }
    
    var issuer: String {
        return ""
    }
    
    var registration: RegistrationClaims {
        return RegistrationClaims()
    }
    
    var prompt: String {
        return ""
    }
}
