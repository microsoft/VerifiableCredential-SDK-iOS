//
//  NetworkingError.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

enum NetworkingError: Error {
    case serviceNotFound
    case invalidRequest
    case unknownNetworkingError
    case invalidUrl
    case serializationError
}
