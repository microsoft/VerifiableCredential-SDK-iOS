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
        
        let idToken = "\(Constants.idToken)=\(try value.idToken.serialize())"
        
        guard let vp = try value.vpToken?.serialize() else {
            throw PresentationResponseEncoderError.noVerifiablePresentationInResponse
        }
        
        let vpToken = "\(Constants.vpToken)=\(vp)"
        
        guard let requestState = value.state else {
            throw PresentationResponseEncoderError.noStatePresentInResponse
        }
        
        let state = "\(Constants.state)=\(requestState)"
        
        let responseBody = "\(idToken)&\(vpToken)&\(state)"
        
        guard let formattedResponse = responseBody.data(using: .ascii) else {
            throw PresentationResponseEncoderError.unableToSerializeResponse
        }
        
        return formattedResponse
    }
}
