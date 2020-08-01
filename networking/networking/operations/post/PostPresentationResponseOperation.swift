//
//  PostPresentationResponse.swift
//  networking
//
//  Created by Sydney Morton on 7/25/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

final class PostPresentationResponseOperation: NetworkOperation {
    
    var successHandler: SuccessHandler
    var failureHandler: FailureHandler
    var urlSession: URLSession
    var urlRequest: URLRequest
    
    private init(request: URLRequest, successHandler: SuccessHandler, failureHandler: FailureHandler, session: URLSession = URLSession.shared) {
        self.urlRequest = request
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        self.urlSession = session
    }
    
    convenience init(withUrl urlStr: String, withBody body: PresentationRequest, serializer: Serializer = Serializer(), urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Constants.POST
        urlRequest.httpBody = serializer.serialize(object: body)
        urlRequest.addValue(Constants.FORM_URLENCODED, forHTTPHeaderField: Constants.CONTENT_TYPE)
        
        let successHandler = SimpleSuccessHandler()
        let failureHandler = SimpleFailureHandler()
        
        self.init(request: urlRequest, successHandler: successHandler, failureHandler: failureHandler, session: urlSession)
    }
}
