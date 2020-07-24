//
//  FetchContractNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/23/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class FetchContractNetworkOperation: FetchNetworkOperation<MockedContract> {
    
    init(withUrl urlStr: String, serializer: Serializer = Serializer(), urlSession: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl
        }
        let urlRequest = URLRequest(url: url)
        super.init(urlRequest: urlRequest, serializer: serializer, urlSession: urlSession)
    }
    
}
