//
//  PostPresentationResponse.swift
//  networking
//
//  Created by Sydney Morton on 7/25/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

class PostPresentationResponse: PostNetworkOperation<PresentationRequest, PresentationServiceResponse> {
    
    convenience init(withUrl urlStr: String, withBody body: PresentationRequest, serializer: MockSerializer = MockSerializer(), urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Constants.POST
        urlRequest.httpBody = serializer.serialize(object: body)
        urlRequest.addValue(Constants.FORM_URLENCODED, forHTTPHeaderField: Constants.CONTENT_TYPE)
        self.init(urlRequest: urlRequest, serializer: serializer, urlSession: urlSession)
    }
}