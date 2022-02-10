/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities
import VCToken

enum PresentationResponseEncoderError: Error {
    case noStatePresentInResponse
    case noVerifiablePresentationInResponse
    case unableToSerializeResponse
}

struct PresentationResponseEncoder: Encoding {
    
    private struct Constants
    {
        static let idToken = "id_token"
        static let vpToken = "vp_token"
        static let state = "state"
    }
    
    func encode(value: PresentationResponse) throws -> Data {
        
//        let idToken = try value.idToken.serialize()
//
//        guard let vp = try value.vpToken?.serialize() else {
//            throw PresentationResponseEncoderError.noVerifiablePresentationInResponse
//        }
//
//        let idTokenQueryItem = URLQueryItem(name: Constants.idToken, value: idToken)
//        let vpTokenQueryItem = URLQueryItem(name: Constants.vpToken, value: vp)
//        let stateQueryItem = URLQueryItem(name: Constants.state, value: value.state)
//
//        var components = URLComponents()
//        components.queryItems = [idTokenQueryItem, vpTokenQueryItem, stateQueryItem]
//
//        guard let formattedResponse = components.query?.data(using: .utf16) else {
//            throw PresentationResponseEncoderError.unableToSerializeResponse
//        }
//
//        return formattedResponse
        return try JSONEncoder().encode(value)
    }
}
