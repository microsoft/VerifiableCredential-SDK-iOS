/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcJwt

public struct IssuanceResponseEncoder: Encoding {
    
    public func encode(value: JwsToken<IssuanceResponseClaims>) throws -> Data {
        
        guard let encodedToken = try value.serialize().data(using: .utf8) else {
            throw NetworkingError.unableToParseString
        }
        
        return encodedToken
    }
    
}