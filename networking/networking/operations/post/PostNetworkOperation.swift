//
//  PostNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/24/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

import Foundation
import PromiseKit

open class PostNetworkOperation<ResponseBody: Codable>: BaseNetworkOperation {
    
    let urlSession: URLSession
    let urlRequest: URLRequest
    let serializer: Serializer
        
    init(urlRequest: URLRequest, serializer: Serializer, urlSession: URLSession) {
        self.urlSession = urlSession
        self.urlRequest = urlRequest
        self.serializer = serializer
    }
    
    func fire() -> Promise<Swift.Result<ResponseBody, Error>> {
        return call(urlSession: self.urlSession, urlRequest: self.urlRequest)
    }
    
    func onSuccess(data: Data, response: HTTPURLResponse) -> Swift.Result<ResponseBody, Error> {
        return defaultOnSuccess(data: data, response: response, serializer: serializer)
    }
    
    func onFailure(data: Data, response: HTTPURLResponse) -> Swift.Result<ResponseBody, Error> {
        return defaultOnFailure(data: data, response: response, serializer: serializer)
    }
}
