/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

struct VerifiableCredentialDescriptor: Codable {
    let context: [String]
    let type: [String]
    let credentialSubject: [String: String]
    let credentialStatus: ServiceDescriptor?
    let exchangeService: ServiceDescriptor?
    let revokeService: ServiceDescriptor?

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case type, credentialSubject, credentialStatus, exchangeService, revokeService
    }
}
