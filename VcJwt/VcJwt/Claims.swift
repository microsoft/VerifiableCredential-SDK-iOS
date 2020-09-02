/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/// Basic Claims within a JWS token.
protocol Claims: Codable {
    
    var iat: String? { get }
    var exp: String? { get }
    var nbf: String? { get }
}

extension Claims {
    var iat: String? {
        return nil
    }
    
    var exp: String? {
        return nil
    }
    
    var nbf: String? {
        return nil
    }
}