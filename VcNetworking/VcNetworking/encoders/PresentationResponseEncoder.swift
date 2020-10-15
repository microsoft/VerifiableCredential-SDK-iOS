/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

enum PresentationResponseEncoderError: Error {
    case noStatePresentInRequest
}

struct PresentationResponseEncoder: Encoding {
    
    func encode(value: PresentationResponse) throws -> Data {
        
        guard let state = value.content.state else {
            throw PresentationResponseEncoderError.noStatePresentInRequest
        }
        
        let encodedBody = try "id_token=" + value.serialize() + "&state=" + state
        guard let encodedToken = encodedBody.data(using: .ascii) else {
            throw NetworkingError.unableToParseString
        }
        
        return encodedToken
    }
}
