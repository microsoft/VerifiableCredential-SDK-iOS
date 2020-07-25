//
//  PostPresentationResponseNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/24/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

let POST = "POST"

class PostPresentationResponseNetworkOperation: PostNetworkOperation<String> {
    
    init(withUrl urlStr: String, withBody body: PresentationServiceResponse, serializer: Serializer = Serializer(), urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = POST
        urlRequest.httpBody = try serializer.serialize(object: body)
        super.init(urlRequest: urlRequest, serializer: serializer, urlSession: urlSession)
    }
    
}
