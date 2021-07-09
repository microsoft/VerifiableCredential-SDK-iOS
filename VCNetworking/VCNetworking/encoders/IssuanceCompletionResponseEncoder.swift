/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

struct IssuanceCompletionResponseEncoder: Encoding {
    
    func encode(value: IssuanceCompletionResponse) throws -> Data {
        do {
            let encodedResponse = try JSONEncoder().encode(value)
            return encodedResponse
        } catch {
            throw NetworkingError.unableToParseString
        }
    }
}
