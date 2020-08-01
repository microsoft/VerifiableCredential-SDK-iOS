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
    
    func onFailure(data: Data, response: HTTPURLResponse) -> Result<Any, Error> {
        let responseBody = serializer.deserialize(data: data) as! String
        switch response.statusCode {
        case 400:
            return .failure(NetworkingError.badRequest(withBody: responseBody))
        case 401:
            return .failure(NetworkingError.unauthorized(withBody: responseBody))
        case 403:
            return .failure(NetworkingError.forbidden(withBody: responseBody))
        case 404:
            return .failure(NetworkingError.notFound(withBody: responseBody))
        case 500...599:
            return .failure(NetworkingError.serverError(withBody: responseBody))
        default:
            return .failure(NetworkingError.unknownNetworkingError(withBody: responseBody))
        }
    }
}
