/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

// TODO Subject to change when Serializer layer is built.
class SimpleSuccessHandler: SuccessHandler {
    
    let serializer: Serializing
    
    init(serializer: Serializing) {
        self.serializer = serializer
    }
    
    func onSuccess<ResponseBody: Codable>(_ type: ResponseBody.Type, data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        return try serializer.deserialize(ResponseBody.self, data: data)
    }
}
