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
    
    var successHandler: SuccessHandler { get }
    var failureHandler: FailureHandler { get }
    var retryHandler: RetryHandler { get }
    var urlSession: URLSession { get }
    var urlRequest: URLRequest { get }
    
    func fire() -> Promise<Swift.Result<String, Error>>
}

extension NetworkOperation {
    
    func fire() -> Promise<Swift.Result<ResponseBody, Error>> {
        return Promise<Swift.Result<ResponseBody, Error>> { seal in
            firstly {
                retryHandler.onRetry {
                    self.call(urlSession: self.urlSession, urlRequest: self.urlRequest)
                }
            }.compactMap { responseBody in
                seal.fulfill(.success(responseBody))
            }.catch { error in
                if error is NetworkingError {
                    seal.fulfill(.failure(error))
                } else {
                    seal.reject(error)
                }
            }
        }
    }
    
    func call(urlSession: URLSession, urlRequest: URLRequest) -> Promise<ResponseBody> {
        let promise = firstly {
            urlSession.dataTask(.promise, with: urlRequest)
        }.then { data, response in
            self.handleResponse(data: data, response: response)
        }
        
        promise.catch { error in
            print(error)
        }
        
        return promise
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Promise<ResponseBody> {
        return Promise { seal in
            
            let successfulStatusCodeRange = 200...299
            
            guard let httpResponse = response as? HTTPURLResponse else {
                seal.reject(NetworkingError.unableToCaseResponse)
                return
            }
            
            if successfulStatusCodeRange.contains(httpResponse.statusCode) {
                seal.fulfill(try self.onSuccess(data: data, response: httpResponse))
                return
            }
            seal.reject(self.onFailure(data: data, response: httpResponse))
        }
    }
    
    func onSuccess(data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        return try self.successHandler.onSuccess(data: data, response: response)
    }
    
    func onFailure(data: Data, response: HTTPURLResponse) -> NetworkingError {
        return self.failureHandler.onFailure(data: data, response: response)
    }
}

