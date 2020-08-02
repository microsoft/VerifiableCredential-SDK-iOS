//
//  SimpleFailureHandler.swift
//  networking
//
//  Created by Sydney Morton on 8/1/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class SimpleFailureHandler: FailureHandler {
    
    let serializer: Serializer
    
    init(serializer: Serializer = Serializer()) {
        self.serializer = serializer
    }
    
    func onFailure(data: Data, response: HTTPURLResponse) -> NetworkingError {
        let responseBody = serializer.deserialize(data: data) as! String
        switch response.statusCode {
        case 400:
            return NetworkingError.badRequest(withBody: responseBody)
        case 401:
            return NetworkingError.unauthorized(withBody: responseBody)
        case 403:
            return NetworkingError.forbidden(withBody: responseBody)
        case 404:
            return NetworkingError.notFound(withBody: responseBody)
        case 500...599:
            return NetworkingError.serverError(withBody: responseBody)
        default:
           return NetworkingError.unknownNetworkingError(withBody: responseBody)
        }
    }
}
