/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

public struct DomainLinkageCredentialSubject: Codable {
    let did: String
    let domainUrl: String
    
    enum CodingKeys: String, CodingKey {
        case did = "id"
        case domainUrl = "origin"
    }
}

public struct DomainLinkageCredentialContent: Codable {
    let context: [String]
    let issuer: String
    let issuanceDate: String
    let expirationDate: String
    let type: [String]
    let credentialSubject: DomainLinkageCredentialSubject
    
    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case issuer, issuanceDate, expirationDate, type, credentialSubject
    }
}

public struct DomainLinkageCredentialClaims: Claims {
    let subject: String
    let issuer: String
    let notValidBefore: Double
    let verifiableCredential: DomainLinkageCredentialContent
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case issuer = "iss"
        case notValidBefore = "nbf"
        case verifiableCredential = "vc"
    }
}

public struct DomainLinkageVerificationInput {
    public let credential: DomainLinkageCredential
    public let document: IdentifierDocument
    public let domainUrl: String
}

public typealias DomainLinkageCredential = JwsToken<DomainLinkageCredentialClaims>
