/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
@testable import VcNetworking

struct MockDecoder: Decoding {
    typealias ResponseBody = MockObject
    
    func decode(data: Data) throws -> MockObject {
        let decoder = JSONDecoder()
        return try decoder.decode(MockObject.self, from: data)
    }
}

struct MockObject: Codable, Equatable {
    let key: String
}
