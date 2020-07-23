//
//  FetchContractNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

class FetchContractNetworkOperation: BaseNetworkOperation {
    typealias T = MockedContract
    
   // var call: () -> Promise<MockedContract>
    
    let urlSession: URLSession
    var urlRequest: URLRequest?
    var serializer: MockSerializer?
        
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func createRequest(withUrl urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidUrl
        }
        self.urlRequest = URLRequest(url: url)
    }
    
    func addSerializer(serializer: MockSerializer) {
        self.serializer = serializer
    }
    
    func fire() -> Promise<Swift.Result<MockedContract, Error>> {
        return Promise { seal in
            call(urlSession: self.urlSession, urlRequest: self.urlRequest!).done { result in
                seal.fulfill(result)
            }.catch { error in
                seal.fulfill(.failure(error))
            }
        }
    }
    
    func onSuccess(data: Data) -> Swift.Result<MockedContract, Error> {
        do {
            if let contract = try self.serializer?.decode(data: data) {
                return .success(contract)
            }
            return .failure(NetworkingError.serializationError)
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
}
