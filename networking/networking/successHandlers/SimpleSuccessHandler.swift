//
//  SimpleSuccessHandler.swift
//  networking
//
//  Created by Sydney Morton on 7/31/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class SimpleSuccessHandler: SuccessHandler {
    
    let serializer: Serializer
    
    init(serializer: Serializer = Serializer()) {
        self.serializer = serializer
    }
    func onSuccess<ResponseBody>(data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        let deserializedObject = serializer.deserialize(data: data) as! ResponseBody
        return deserializedObject
    }
}
