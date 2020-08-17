/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation


struct VerifiableCredential: Serializable {
    let raw: Data
    let contents: VerifiableCredentialContent
    let token: JwsToken
    
    init(with serializer: Serializer, data: Data) throws {
        let jwsToken = try serializer.deserialize(JwsToken.self, data: data)
        self.token = jwsToken
        
        guard let tokenContent = jwsToken.content.fromBase64URL() else {
            throw SerializationError.malFormedObject(withData: data)
        }
        
        let vcContent = try serializer.deserialize(VerifiableCredentialContent.self, data: (tokenContent.data(using: .utf8))!)
        self.contents = vcContent
        self.raw = data
    }

    func serialize(to serializer: Serializer) throws -> Data {
        return self.raw
    }
}

struct VerifiableCredentialContent: JSONSerializable {
    let jti: String
    let vc: VerifiableCredentialDescriptor
    let iss, sub: String
    let iat, exp: Int
}

struct VerifiableCredentialDescriptor: JSONSerializable {
    let context: [String]
    let type: [String]
    let credentialSubject: [String: JSON]
    let credentialStatus: ServiceDescriptor?
    let exchangeService: ServiceDescriptor?
    let revokeService: ServiceDescriptor?

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case type, credentialSubject, credentialStatus, exchangeService, revokeService
    }
}

struct ServiceDescriptor: JSONSerializable {
    let id: String
    let type: String
}
