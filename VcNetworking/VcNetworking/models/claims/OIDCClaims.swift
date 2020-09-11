/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt

protocol OIDCClaims: Claims {
    var responseType: String { get }
    var responseMode: String { get }
    var clientID: String { get }
    var redirectURI: String { get }
    var scope: String? { get }
    var state: String? { get }
    var nonce: String? { get }
    var iss: String? { get }
    var registration: RegistrationClaims? { get }
    var prompt: String? { get }
}

extension OIDCClaims {
    var scope: String? {
        return nil
    }

    var state: String? {
        return nil
    }
    
    var nonce: String? {
        return nil
    }
    
    var iss: String? {
        return nil
    }
    
    var registration: RegistrationClaims? {
        return nil
    }
    
    var prompt: String? {
        return nil
    }
}
