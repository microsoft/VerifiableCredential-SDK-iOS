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

open class PostNetworkOperation<ResponseBody, RequestBody>: BaseNetworkOperation {
    
    let urlSession: URLSession
    var urlRequest: URLRequest
    let serializer: Serializer
        
    init(urlRequest: URLRequest, serializer: Serializer, urlSession: URLSession) {
        self.urlSession = urlSession
        self.urlRequest = urlRequest
        self.serializer = serializer
        
        self.urlRequest.httpMethod = Constants.POST
    }
    
    convenience init(withUrl urlStr: String, withBody body: RequestBody, serializer: Serializer = Serializer(), urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Constants.POST
        urlRequest.httpBody = serializer.serialize(object: body)
        self.init(urlRequest: urlRequest, serializer: serializer, urlSession: urlSession)
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

class PostIssuanceResponse: PostNetworkOperation<IssuanceResponse, IssuanceServiceResponse> {}
class PostExchangeRequest: PostNetworkOperation<ExchangeRequest, ExchangeServiceResponse> {}
