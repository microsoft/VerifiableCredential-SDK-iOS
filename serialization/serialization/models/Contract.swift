//
//  Contract.swift
//  serialization
//
//  Created by Sydney Morton on 7/28/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

struct Contract: Codable, Serializable {
    let id: String
    let display: Display
    let input: Input
}

struct Display: Codable, Serializable {
    let id, locale: String
    let contract: String
    let card: Card
    let consent: Consent
    let claims: [String: Claims]
}

struct Card: Codable, Serializable {
    let title, issuedBy, backgroundColor, textColor: String
    let logo: Logo
    let cardDescription: String

    enum CodingKeys: String, CodingKey {
        case title, issuedBy, backgroundColor, textColor, logo
        case cardDescription = "description"
    }
}

struct Claims: Codable, Serializable {
    let type, label: String
}

struct Logo: Codable, Serializable {
    let uri: String
    let logoDescription: String

    enum CodingKeys: String, CodingKey {
        case uri
        case logoDescription = "description"
    }
}

struct Consent: Codable, Serializable {
    let title, instructions: String
}

struct Input: Codable, Serializable {
    let id: String
    let credentialIssuer: String
    let issuer: String
    let attestations: Attestations
}

struct Attestations: Codable, Serializable {
    let idTokens: [IDToken]
}

struct IDToken: Codable, Serializable {
    let encrypted: Bool
    let claims: [Claim]
    let idTokenRequired: Bool
    let configuration: String
    let clientID: String
    let redirectURI: String

    enum CodingKeys: String, CodingKey {
        case encrypted, claims
        case idTokenRequired = "required"
        case configuration
        case clientID = "client_id"
        case redirectURI = "redirect_uri"
    }
}

struct Claim: Codable, Serializable {
    let claim: String
    let claimRequired, indexed: Bool

    enum CodingKeys: String, CodingKey {
        case claim
        case claimRequired = "required"
        case indexed
    }
}
