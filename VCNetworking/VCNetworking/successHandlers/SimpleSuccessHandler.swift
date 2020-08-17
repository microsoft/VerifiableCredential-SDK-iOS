/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCSerialization

// TODO Subject to change when Serializer layer is built.
class SimpleSuccessHandler: SuccessHandler {
    
    let serializer: Serializer
    
    init(serializer: Serializer = Serializer()) {
        self.serializer = serializer
    }
    
    func onSuccess<ResponseBody: Serializable>(_ type: ResponseBody.Type, data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        return try serializer.deserialize(ResponseBody.self, data: data)
    }
}
