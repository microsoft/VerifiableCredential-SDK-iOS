/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

struct PresentationResponseEncoder: Encoding {
    
    func encode(value: PresentationResponse) throws -> Data {
        
        guard let encodedToken = try value.serialize().data(using: .ascii) else {
            throw NetworkingError.unableToParseString
        }
        
        return encodedToken
    }
}
