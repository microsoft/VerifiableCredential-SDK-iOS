/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

final class PostPresentationResponseOperation: NetworkOperation {
    typealias SuccessHandler = SimpleSuccessHandler

    let successHandler: SuccessHandler = SimpleSuccessHandler(decoder: PresentationServiceResponseDecoder())
    let failureHandler: FailureHandling = SimpleFailureHandler()
    let retryHandler: RetryHandler = NoRetry()
    let urlSession: URLSession
    let urlRequest: URLRequest
    
    init(withUrl urlStr: String, withBody body: MockPresentationRequest, serializer: Serializing, urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Constants.POST
        urlRequest.httpBody = try serializer.serialize(object: body)
        urlRequest.addValue(Constants.FORM_URLENCODED, forHTTPHeaderField: Constants.CONTENT_TYPE)
        self.urlRequest = urlRequest
        self.urlSession = urlSession
    }
}
