//
//  BaseNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

/**
* Base Network Operation class with default methods for all Network Operations.
* ResponseBody: the type of object returned by the service.
*/
protocol BaseNetworkOperation {
    associatedtype ResponseBody
    
    func fire() -> Promise<Swift.Result<ResponseBody, Error>>
    
    func onSuccess(data: Data, response: HTTPURLResponse) -> Swift.Result<ResponseBody, Error>
    
    func onFailure(data: Data, response: HTTPURLResponse) -> Swift.Result<ResponseBody, Error>
}

extension BaseNetworkOperation {
    
    func call(urlSession: URLSession, urlRequest: URLRequest) -> Promise<Swift.Result<ResponseBody, Error>> {
        let promise = firstly {
            urlSession.dataTask(.promise, with: urlRequest)
        }.then { data, response in
            self.handleResponse(data: data, response: response)
        }
        return promise
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Promise<Swift.Result<ResponseBody, Error>> {
        return Promise { seal in
            
            let successfulStatusCodeRange = 200...299
            
            do {
                let httpResponse = try response.convertToHttpUrlResponse()
                if successfulStatusCodeRange.contains(httpResponse.statusCode) {
                    seal.fulfill(self.onSuccess(data: data, response: httpResponse))
                }
                seal.fulfill(self.onFailure(data: data, response: httpResponse))
            } catch {
                seal.fulfill(.failure(error))
            }
        }
    }
    
    func defaultOnSuccess(data: Data, response: HTTPURLResponse, serializer: Serializer) -> Swift.Result<ResponseBody, Error> {
        let deserializedObject = serializer.deserialize(data: data)
        return .success(deserializedObject as! Self.ResponseBody)
    }
    
    func defaultOnFailure(data: Data, response: HTTPURLResponse, serializer: Serializer) -> Swift.Result<ResponseBody, Error> {
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

