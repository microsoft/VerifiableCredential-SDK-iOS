//
//  Contract.swift
//  serialization
//
//  Created by Sydney Morton on 7/27/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

@testable import serialization

struct MockContract: Codable, Serializable {
    let test: String
    let id: String
}
