//
//  BaseNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit
import Serialization

/**
* Base Network Operation class with default methods for all Network Operations.
* ResponseBody: the type of object returned by the service.
*/
protocol BaseNetworkOperation {
    associatedtype ResponseBody: Serializable
    
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
        do {
            let deserializedObject = try serializer.deserialize(ResponseBody.self, data: data)
            return .success(deserializedObject)
        } catch {
            return .failure(error)
        }
    }
    
    func defaultOnFailure(data: Data, response: HTTPURLResponse, serializer: Serializer) -> Swift.Result<ResponseBody, Error> {
        do {
            let responseBody = try serializer.deserialize(ResponseBody.self, data: data)
            switch response.statusCode {
            case 400:
                return .failure(NetworkingError.badRequest(withBody: responseBody as! String))
            case 401:
                return .failure(NetworkingError.unauthorized(withBody: responseBody as! String))
            case 403:
                return .failure(NetworkingError.forbidden(withBody: responseBody as! String))
            case 404:
                return .failure(NetworkingError.notFound(withBody: responseBody as! String))
            case 500...599:
                return .failure(NetworkingError.serverError(withBody: responseBody as! String))
            default:
                return .failure(NetworkingError.unknownNetworkingError(withBody: responseBody as! String))
            }
        } catch {
            return .failure(error)
        }
    }
}

