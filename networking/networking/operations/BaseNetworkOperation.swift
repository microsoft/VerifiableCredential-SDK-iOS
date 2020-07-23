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
    associatedtype T
    
    // var call: () -> Promise<T> { get }
    
    func fire() -> Promise<Swift.Result<T, Error>>
    
    func onSuccess(data: Data) -> Swift.Result<T, Error>
    
    func onFailure(response: HTTPURLResponse) -> Swift.Result<T, Error>
}

extension BaseNetworkOperation {
    func call(urlSession: URLSession, urlRequest: URLRequest) -> Promise<Swift.Result<T, Error>> {
        return firstly {
                urlSession.dataTask(.promise, with: urlRequest)
            }.compactMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.unknownNetworkingError
                }
                return self.handleResponse(data: data, response: httpResponse)
            }
        }
    
    private func handleResponse(data: Data, response: HTTPURLResponse) -> Swift.Result<T, Error> {
        if response.statusCode < 400 {
            return self.onSuccess(data: data)
        }
        return self.onFailure(response: response)
    }
}

