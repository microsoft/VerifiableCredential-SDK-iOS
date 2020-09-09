/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcJwt

struct PresentationResponseEncoder: Encoding {
    
    func encode(value: String) throws -> Data {
        return value.data(using: .utf8)!
    }
    
}
