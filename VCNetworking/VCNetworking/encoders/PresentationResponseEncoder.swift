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
    
    let jsonEncoder = JSONEncoder()
    
    func encode(value: PresentationResponse) throws -> Data {
        return try jsonEncoder.encode(value)
    }
}
