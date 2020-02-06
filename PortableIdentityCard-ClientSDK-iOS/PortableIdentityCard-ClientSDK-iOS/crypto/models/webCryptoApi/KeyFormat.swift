//
//  KeyFormat.swift
//  PhoneFactor
//
//  Created by Sydney Morton on 1/27/20.
//  Copyright © 2020 PhoneFactor. All rights reserved.
//

/**
 Specifies a serialization format for a key.
 */
enum KeyFormat: String, Codable {
    /// An unformatted sequence of bytes. Intended for secret keys
    case Raw = "raw"
    /// The DER encoding of the PrivateKEyInfo structure from RFC 5208
    case Pkcs8 = "pkcs8"
    /// The DER encoding of the SubjectPublicKeyInfo structure from RFC 5280
    case Spki = "spki"
    /// The key is a JsonWebKey dictionary encoded as a JavaScript object
    case Jwk = "jwk"
}
