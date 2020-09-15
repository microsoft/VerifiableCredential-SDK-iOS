/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

@testable import VCRepository

class MockDecoder: Decoding {
    typealias ResponseBody = String
    
    func decode(data: Data) throws -> String {
        return String(data: data, encoding: .utf8)!
    }
}
