/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public struct IssuerIdToken: Equatable {
    
    public let raw: String
    
    public  let token: JwsToken<IssuerIdTokenClaims>
    
    public init?(from rawToken: String) {
        self.raw = rawToken
    
        guard let jws = JwsToken<IssuerIdTokenClaims>(from: rawToken) else {
            return nil
        }
        
        self.token = jws
    }
    
    public static func == (lhs: IssuerIdToken, rhs: IssuerIdToken) -> Bool {
        return lhs.raw == rhs.raw
    }
}
