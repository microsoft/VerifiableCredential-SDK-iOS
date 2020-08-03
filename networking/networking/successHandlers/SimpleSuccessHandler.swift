//
//  SimpleSuccessHandler.swift
//  networking
//
//  Created by Sydney Morton on 7/31/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

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
