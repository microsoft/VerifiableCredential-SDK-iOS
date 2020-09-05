/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcJwt

struct PresentationServiceResponseDecoder: Decoding {
    typealias Decodable = JwsToken<VcClaims>
    
    let jwsDecoder = JwsDecoder()
    let jsonDecoder = JSONDecoder()
    
    func decode(data: Data) throws -> JwsToken<VcClaims> {
        let response = try jsonDecoder.decode(Response.self, from: data)
        let jwt = try jwsDecoder.decode(VcClaims.self, token: response.vc)
        return jwt
    }
}

struct VcClaims: Claims {
    let vc: String
}

fileprivate struct Response: Codable {
    let vc: String
}
