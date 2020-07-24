//
//  BaseNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

protocol BaseNetworkOperation {
    associatedtype T: Codable
    
    func fire() -> Promise<Swift.Result<T, Error>>
    
    func onSuccess(data: Data, response: HTTPURLResponse) -> Swift.Result<T, Error>
    
    func onFailure(data: Data, response: HTTPURLResponse) -> Swift.Result<T, Error>
}

extension BaseNetworkOperation {
    
    func call(urlSession: URLSession, urlRequest: URLRequest) -> Promise<Swift.Result<T, Error>> {
        let promise = firstly {
            urlSession.dataTask(.promise, with: urlRequest)
        }.then { data, response in
            self.handleResponse(data: data, response: response)
        }
        return promise
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Promise<Swift.Result<T, Error>> {
        return Promise { seal in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                seal.reject(NetworkingError.invalidRequest)
                return
            }
            
            if httpResponse.statusCode < 400 {
                seal.fulfill(self.onSuccess(data: data, response: httpResponse))
            }
            seal.fulfill(self.onFailure(data: data, response: httpResponse))
        }
    }
    
    func defaultOnSuccess(data: Data, response: URLResponse, serializer: Serializer) -> Swift.Result<T, Error> {
        do {
            let deserializedObject = try serializer.deserialize(type: T.self, data: data)
            return .success(deserializedObject)
        } catch {
            return .failure(error)
        }
    }
    
    func defaultOnFailure(data: Data, response: HTTPURLResponse, serializer: Serializer) -> Swift.Result<T, Error> {
        switch response.statusCode {
        case 400:
            return .failure(NetworkingError.invalidRequest)
        default:
            return .failure(NetworkingError.unknownNetworkingError)
        }
    }
}

