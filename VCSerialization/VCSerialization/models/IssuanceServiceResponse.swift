/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt

public struct IssuanceServiceResponse: Serializable {
    let token: JwsToken<VcClaims>
    
    init(token: JwsToken<VcClaims>) {
        self.token = token
    }
    
    public init(with serializer: Serializer, data: Data) throws {
        let response = try serializer.jsonDecoder.decode(ServiceResponse.self, from: data)
        self.token = try serializer.jwsDecoder.decode(VcClaims.self, token: response.vc)
    }
    
    public func serialize(to serializer: Serializer) throws -> Data {
        let serializedResponse = try serializer.jwsEncoder.encode(self.token).data(using: .utf8)
        
        guard let encodedResponse = serializedResponse else {
            throw SerializationError.nullData
        }
        
        return encodedResponse
    }
}

fileprivate struct ServiceResponse: Codable {
    let vc: String
}
