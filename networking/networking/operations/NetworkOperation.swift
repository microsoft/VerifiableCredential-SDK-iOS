//
//  BaseNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import PromiseKit

/**
 * Base Network Operation class with default methods for all Network Operations.
 * ResponseBody: the type of object returned by the service.
 */
protocol NetworkOperation {
    associatedtype ResponseBody
    
    var successHandler: SuccessHandler { get set }
    var failureHandler: FailureHandler { get set }
    var urlSession: URLSession { get set }
    var urlRequest: URLRequest { get set }
    
    init()
    
    func fire() -> Promise<Swift.Result<ResponseBody, Error>>
    
    func onSuccess(data: Data, response: HTTPURLResponse) -> Swift.Result<ResponseBody, Error>
    
    func onFailure(data: Data, response: HTTPURLResponse) -> Swift.Result<ResponseBody, Error>
}

extension NetworkOperation {
    
    init(request: URLRequest, successHandler: SuccessHandler, failureHandler: FailureHandler, session: URLSession = URLSession.shared) {
        self.init()
        self.urlRequest = request
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        self.urlSession = session
    }
    
    func fire() -> Promise<Swift.Result<Any, Error>> {
        return call(urlSession: self.urlSession, urlRequest: self.urlRequest)
    }
    
    func call(urlSession: URLSession, urlRequest: URLRequest) -> Promise<Swift.Result<Any, Error>> {
        let promise = firstly {
            urlSession.dataTask(.promise, with: urlRequest)
        }.then { data, response in
            self.handleResponse(data: data, response: response)
        }
        return promise
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Promise<Swift.Result<Any, Error>> {
        return Promise { seal in
            
            let successfulStatusCodeRange = 200...299
            
            guard let httpResponse = response as? HTTPURLResponse else {
                seal.reject(NetworkingError.unableToCaseResponse)
                return
            }
            
            if successfulStatusCodeRange.contains(httpResponse.statusCode) {
                seal.fulfill(self.onSuccess(data: data, response: httpResponse))
                return
            }
            seal.fulfill(self.onFailure(data: data, response: httpResponse))
        }
    }
    
    func onSuccess(data: Data, response: HTTPURLResponse) -> Swift.Result<Any, Error> {
        return self.successHandler.onSuccess(data: data, response: response)
    }
    
    func onFailure(data: Data, response: HTTPURLResponse) -> Swift.Result<Any, Error> {
        return self.failureHandler.onFailure(data: data, response: response)
    }
}
