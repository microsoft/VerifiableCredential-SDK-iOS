/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
@testable import VcNetworking

struct MockDecoder: Decoding {
    typealias ResponseBody = MockSerializableObject
    
    let jsonDecoder = JSONDecoder()
    
    func decode(data: Data) throws -> MockSerializableObject {
        return try jsonDecoder.decode(MockSerializableObject.self, from: data)
    }
}

