/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt

public struct IssuanceResponse: Serializable {
    
    let token: JwsToken<IssuanceResponseClaims>
    
    public init(with serializer: Serializer, data: Data) throws {
        self.token = try serializer.jwsDecoder.decode(IssuanceResponseClaims.self, token: String(data: data, encoding: .utf8)!)
    }
    
    public func serialize(to serializer: Serializer) throws -> Data {
        let serializedToken = try serializer.jwsEncoder.encode(self.token)
        return serializedToken.data(using: .utf8)!
    }
}
