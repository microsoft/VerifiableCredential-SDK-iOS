/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

public struct Contract: Codable {

    let id: String
    let display: Display
    let input: Input
}

struct Display: Codable {
    let id, locale: String
    let contract: String
    let card: Card
    let consent: Consent
    let claims: [String: vcClaims]
}

struct Card: Codable {
    let title, issuedBy, backgroundColor, textColor: String
    let logo: Logo
    let cardDescription: String

    enum CodingKeys: String, CodingKey {
        case title, issuedBy, backgroundColor, textColor, logo
        case cardDescription = "description"
    }
}

struct vcClaims: Codable {
    let type, label: String
}

struct Logo: Codable {
    let uri: String
    let logoDescription: String

    enum CodingKeys: String, CodingKey {
        case uri
        case logoDescription = "description"
    }
}

struct Consent: Codable {
    let title, instructions: String
}

struct Input: Codable {
    let id: String
    let credentialIssuer: String
    let issuer: String
    let attestations: Attestations
}

struct Attestations: Codable {
    let selfIssued: SelfIssued?
    let presentations: [Presentation]?
    let idTokens: [IDToken]?
}

struct IDToken: Codable {
    let encrypted: Bool?
    let claims: [Claim]
    let idTokenRequired: Bool
    let configuration: String
    let clientID: String?
    let redirectURI: String?

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case idTokenRequired = "required"
        case configuration
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
    }
}

struct Presentation: Codable {
    let encrypted: Bool?
    let claims: [Claim]
    let presentationRequired: Bool
    let credentialType: String
    let issuers: [Issuer]?
    let contracts: [String]?

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case presentationRequired = "required"
        case credentialType, issuers, contracts
    }
}

struct Issuer: Codable {
    let iss: String
}

struct SelfIssued: Codable {
    let encrypted: Bool?
    let claims: [Claim]?
    let selfIssuedRequired: Bool?

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case selfIssuedRequired = "required"
    }
}

struct Claim: Codable {
    let claim: String?
    let claimRequired, indexed: Bool?

    enum CodingKeys: String, CodingKey {
        case claim
        case claimRequired = "required"
        case indexed
    }
}
