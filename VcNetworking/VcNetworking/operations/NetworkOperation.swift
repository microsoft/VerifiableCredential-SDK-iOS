/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit

internal protocol InternalNetworkOperation: NetworkOperation & InternalOperation {}

public protocol NetworkOperation {
    associatedtype ResponseBody
    
    func fire() -> Promise<ResponseBody>
}

protocol InternalOperation {
    associatedtype Decoder: Decoding
    associatedtype ResponseBody where Decoder.ResponseBody == ResponseBody
    
    var decoder: Decoder { get }
    var successHandler: SuccessHandler { get }
    var failureHandler: FailureHandler { get }
    var retryHandler: RetryHandler { get }
    var urlSession: URLSession { get }
    var urlRequest: URLRequest { get }
}

extension InternalNetworkOperation {
    
    var successHandler: SuccessHandler {
        return SimpleSuccessHandler()
    }
    
    var failureHandler: FailureHandler {
        return SimpleFailureHandler()
    }
    
    var retryHandler: RetryHandler {
        return NoRetry()
    }
    
    var urlSession: URLSession {
        return URLSession.shared
    }
    
    public func fire() -> Promise<ResponseBody> {
        return firstly {
            retryHandler.onRetry {
                self.call(urlSession: self.urlSession, urlRequest: self.urlRequest)
            }
        }
    }
    
    private func call(urlSession: URLSession, urlRequest: URLRequest) -> Promise<ResponseBody> {
        return firstly {
            urlSession.dataTask(.promise, with: urlRequest)
        }.then { data, response in
            self.handleResponse(data: data, response: response)
        }
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Promise<ResponseBody> {
        return Promise { seal in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                seal.reject(NetworkingError.unableToParseData)
                return
            }
            
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                seal.fulfill(try self.onSuccess(data: data, response: httpResponse))
                return
            }
            seal.reject(try self.onFailure(data: data, response: httpResponse))
        }
    }
    
    private func onSuccess(data: Data, response: HTTPURLResponse) throws -> ResponseBody {
        return try self.successHandler.onSuccess(data: data, decodeWith: self.decoder)
    }
    
    private func onFailure(data: Data, response: HTTPURLResponse) throws -> NetworkingError {
        return try self.failureHandler.onFailure(data: data, response: response)
    }
}
