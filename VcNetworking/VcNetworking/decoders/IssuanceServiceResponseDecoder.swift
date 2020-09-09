/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcJwt

struct IssuanceServiceResponseDecoder: Decoding {
    
    let jwsDecoder = JwsDecoder()
    let jsonDecoder = JSONDecoder()
    
    func decode(data: Data) throws -> JwsToken<VCClaims> {
        let response = try jsonDecoder.decode(Response.self, from: data)
        
        guard let token = JwsToken<VCClaims>(from: response.vc) else {
            throw DecodingError.unableToDecodeToken
        }
        
        return token
    }
}

fileprivate struct Response: Codable {
    let vc: String
}
