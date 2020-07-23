//
//  mockSerializer.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class MockSerializer {
    
    func decode(data: Data) throws -> MockedContract {
        return try JSONDecoder().decode(MockedContract.self, from: data)
    }
    
}
