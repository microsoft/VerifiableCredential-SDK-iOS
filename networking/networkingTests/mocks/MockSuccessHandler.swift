//
//  MockSuccessHandler.swift
//  networkingTests
//
//  Created by Sydney Morton on 8/2/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class MockSuccessHandler: SuccessHandler {
    
    func onSuccess<ResponseBody>(data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        return String(data: data, encoding: .utf8) as! ResponseBody
    }
    
    
}
