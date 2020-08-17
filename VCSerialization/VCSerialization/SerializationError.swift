//
//  SerializationError.swift
//  serialization
//
//  Created by Sydney Morton on 7/28/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

public enum SerializationError: Error {
    case nullData
    case unableToStringifyData(withData: Data)
    case malFormedObject(withData: Data)
}
