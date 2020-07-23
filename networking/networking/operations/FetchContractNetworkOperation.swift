//
//  FetchContractNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

class FetchContractNetworkOperation {
    typealias T = MockedContract
    
   // var call: () -> Promise<MockedContract>
    
    let urlSession: URLSession
    let url: URL
        
    init(urlSession: URLSession = URLSession.shared, url: URL) {
        self.urlSession = urlSession
        self.url = url
    }
    
    func fire() -> Promise<Swift.Result<MockedContract, Error>> {
        return Promise { seal in
            call().done { result in
                print(result)
                seal.fulfill(result)
            }.catch { error in
                print(error)
                seal.fulfill(.failure(error))
            }
        }
    }
    
    func onSuccess(data: Data) -> Swift.Result<MockedContract, Error> {
        do {
            let contract = try JSONDecoder().decode(MockedContract.self, from: data)
            return .success(contract)
        } catch {
            return .failure(error)
        }
    }
    
    func onFailure(response: HTTPURLResponse) -> Swift.Result<MockedContract, Error> {
        switch response.statusCode {
        case 400:
            return .failure(NetworkingError.invalidRequest)
        default:
            return .failure(NetworkingError.unknownNetworkingError)
        }
    }
    
    func call() -> Promise<Swift.Result<MockedContract, Error>> {
        return firstly {
                urlSession.dataTask(.promise, with: url)
            }.compactMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.unknownNetworkingError
                }
                return self.handleResponse(data: data, response: httpResponse)
            }
        }
    
    private func handleResponse(data: Data, response: HTTPURLResponse) -> Swift.Result<MockedContract, Error> {
        if response.statusCode < 400 {
            return self.onSuccess(data: data)
        }
        return self.onFailure(response: response)
    }
}
