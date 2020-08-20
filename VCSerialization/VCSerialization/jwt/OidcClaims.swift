/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import SwiftJWT

public protocol OidcClaims: Claims {
    var responseType: String { get }
    var responseMode: String { get }
    var clientID: String { get }
    var redirectURI: String { get }
    var scope: String { get }
    var state: String? { get }
    var nonce: String? { get }
    var iss: String { get }
    var registration: Registration? { get }
    var prompt: String? { get }
}

extension OidcClaims {
    var state: String? {
        return nil
    }
    
    var nonce: String? {
        return nil
    }
    
    var registration: Registration? {
        return nil
    }
    
    var prompt: String? {
        return nil
    }
}

public struct Registration: Codable {
    let clientName: String
    let clientPurpose: String
    let clientUri: String
    let tosURI: String
    let logoURI: String
    
    init() {
        clientName = ""
        clientPurpose = ""
        clientUri = ""
        tosURI = ""
        logoURI = ""
    }

    enum CodingKeys: String, CodingKey {
        case clientName = "client_name"
        case clientPurpose = "client_purpose"
        case clientUri = "client_uri"
        case tosURI = "tos_uri"
        case logoURI = "logo_uri"
    }
}
