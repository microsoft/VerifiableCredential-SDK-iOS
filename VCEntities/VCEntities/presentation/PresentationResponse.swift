/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

enum PresentationResponseDecodingError: Error {
    case unableToDecodeIdToken
    case unableToDecodeVpToken
}

public struct PresentationResponse: Codable {
    
    public let idToken: PresentationResponseToken
    
    public let vpToken: VerifiablePresentation?
    
    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
        case vpToken = "vp_token"
    }
    
    public init(idToken: PresentationResponseToken, vpToken: VerifiablePresentation?) {
        self.idToken = idToken
        self.vpToken = vpToken
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let idTokenSerialized = try values.decodeIfPresent(String.self, forKey: .idToken),
           let token = JwsToken<PresentationResponseClaims>(from: idTokenSerialized) {
            idToken = token
        } else {
            throw PresentationResponseDecodingError.unableToDecodeIdToken
        }
        if let vpTokenSerialized = try values.decodeIfPresent(String.self, forKey: .vpToken),
           let vp = VerifiablePresentation(from: vpTokenSerialized) {
               vpToken = vp
        } else {
            throw PresentationResponseDecodingError.unableToDecodeVpToken
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(idToken.rawValue, forKey: .idToken)
        try container.encodeIfPresent(vpToken?.rawValue, forKey: .vpToken)
    }
}
