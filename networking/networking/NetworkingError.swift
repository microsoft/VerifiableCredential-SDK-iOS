//
//  NetworkingError.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

enum NetworkingError: Error, Equatable {
    
    case badRequest(withBody: String)
    case forbidden(withBody: String)
    case invalidUrl(withUrl: String)
    case notFound(withBody: String)
    case serverError(withBody: String)
    case unauthorized(withBody: String)
    case unknownNetworkingError(withBody: String)
    case unableToCaseResponse
}
