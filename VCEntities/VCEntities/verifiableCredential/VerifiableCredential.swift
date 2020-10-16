/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

public struct VerifiableCredential {
    
    public let raw: String
    public let token: JwsToken<VCClaims>
    
    public init?(from serializedToken: String) {
        
        guard let token = JwsToken<VCClaims>(from: serializedToken) else {
            return nil
        }
        
        self.token = token
        self.raw = serializedToken
    }
    
}
