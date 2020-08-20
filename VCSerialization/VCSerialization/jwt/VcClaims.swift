/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import SwiftJWT

struct VcClaims: Claims {
    let jti: String
    let iss: String
    let sub: String
    let vc: VerifiableCredentialDescriptor
}

struct VerifiableCredentialDescriptor: Codable {
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

struct ServiceDescriptor: Codable {
    let id: String
    let type: String
}