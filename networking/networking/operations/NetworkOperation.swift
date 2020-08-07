/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import Serialization

/**
 * Base Network Operation class with default methods for all Network Operations.
 * ResponseBody: the type of object returned by the service.
 */
public protocol NetworkOperation {
    associatedtype ResponseBody: Serializable
    
    var successHandler: SuccessHandler { get }
    var failureHandler: FailureHandler { get }
    var retryHandler: RetryHandler { get }
    var urlSession: URLSession { get }
    var urlRequest: URLRequest { get }
    
    func fire() -> Promise<ResponseBody>
}

extension NetworkOperation {
    
    public func fire() -> Promise<ResponseBody> {
        return firstly {
            retryHandler.onRetry {
                self.call(urlSession: self.urlSession, urlRequest: self.urlRequest)
            }
        }
    }
    
    func call(urlSession: URLSession, urlRequest: URLRequest) -> Promise<ResponseBody> {
        return firstly {
            urlSession.dataTask(.promise, with: urlRequest)
        }.then { data, response in
            self.handleResponse(data: data, response: response)
        }
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Promise<ResponseBody> {
        return Promise { seal in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                seal.reject(NetworkingError.unableToCaseResponse)
                return
            }
            
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                seal.fulfill(try self.onSuccess(data: data, response: httpResponse))
                return
            }
            seal.reject(try self.onFailure(data: data, response: httpResponse))
        }
    }
    
    func onSuccess(data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        return try self.successHandler.onSuccess(ResponseBody.self, data: data, response: response)
    }
    
    func onFailure(data: Data, response: HTTPURLResponse) throws -> NetworkingError {
        return try self.failureHandler.onFailure(ResponseBody.self, data: data, response: response)
    }
}

