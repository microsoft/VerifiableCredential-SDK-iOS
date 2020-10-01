/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

public struct PresentationRequestDecoder: Decoding {
    
    public func decode(data: Data) throws -> PresentationRequest {
        
        guard let token = PresentationRequest(from: data) else {
            throw DecodingError.unableToDecodeToken
        }
        
        return token
    }
}
