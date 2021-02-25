/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VCEntities

public class PostPresentationResponseOperation: InternalPostNetworkOperation {

    typealias Encoder = PresentationResponseEncoder
    public typealias RequestBody = PresentationResponse
    public typealias ResponseBody = String?
    
    let decoder = PresentationServiceResponseDecoder()
    let encoder = PresentationResponseEncoder()
    let urlSession: URLSession
    let urlRequest: URLRequest
    
    public init(usingUrl urlStr: String, withBody body: PresentationResponse, urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        var request = URLRequest(url)
        request.httpMethod = Constants.POST
        request.httpBody = try self.encoder.encode(value: body)
        request.setValue(Constants.FORM_URLENCODED, forHTTPHeaderField: Constants.CONTENT_TYPE)
        
        self.urlRequest = request
        self.urlSession = urlSession
    }
}
