/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

public struct IssuerIdToken {
    
    public let raw: String
    
    public  let token: JwsToken<IssuerIdTokenClaims>
    
    public init?(from rawToken: String) {
        self.raw = rawToken
    
        guard let jws = JwsToken<IssuerIdTokenClaims>(from: rawToken) else {
            return nil
        }
        
        self.token = jws
    }
}
