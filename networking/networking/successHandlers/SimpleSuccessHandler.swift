/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

// TODO Subject to change when Serializer layer is built.
class SimpleSuccessHandler: SuccessHandler {
    
    let serializer: Serializer
    
    init(serializer: Serializer = Serializer()) {
        self.serializer = serializer
    }
    
    func onSuccess<ResponseBody>(_ type: ResponseBody.Type, data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        return serializer.deserialize(data: data) as! ResponseBody
    }
}
