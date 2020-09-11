/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/// Basic Claims within a JWS token.
public protocol Claims: Codable {
    
    var iat: String { get }
    var exp: String { get }
    var nbf: String { get }
}

public extension Claims {
    var iat: String {
        return ""
    }
    
    var exp: String {
        return ""
    }
    
    var nbf: String {
        return ""
    }
}
