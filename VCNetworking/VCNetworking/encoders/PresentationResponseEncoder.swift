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
        
        let idTokenParam = "\(Constants.idToken)=\(try value.idToken.serialize())"
        
        guard let vpToken = value.vpToken else {
            throw PresentationResponseEncoderError.noVerifiablePresentationInResponse
        }
        
        let vpTokenParam = "\(Constants.vpToken)=\(try vpToken.serialize())"
        
        guard let state = value.state?.stringByAddingPercentEncodingForRFC3986() else {
            throw PresentationResponseEncoderError.noStatePresentInResponse
        }
        
        let stateParam = "\(Constants.state)=\(state)"
        
        let responseBody = "\(idTokenParam)&\(vpTokenParam)&\(stateParam)"
        
        guard let response = responseBody.data(using: .utf8) else
        {
            throw PresentationResponseEncoderError.unableToSerializeResponse
        }
        
        return response
    }
}
