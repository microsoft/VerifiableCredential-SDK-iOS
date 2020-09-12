/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcJwt

public class PostIssuanceResponseOperation: NetworkOperation {
    public typealias ResponseBody = VerifiableCredential
    
    public let decoder = IssuanceServiceResponseDecoder()
    let encoder = IssuanceResponseEncoder()
    public let urlSession: URLSession
    public let urlRequest: URLRequest
    
    public init(withUrl urlStr: String, withBody body: JwsToken<IssuanceResponseClaims>, urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Constants.POST
        urlRequest.httpBody = try self.encoder.encode(value: body)
        urlRequest.addValue(Constants.FORM_URLENCODED, forHTTPHeaderField: Constants.CONTENT_TYPE)
        self.urlRequest = urlRequest
        self.urlSession = urlSession
    }
}

public typealias VerifiableCredential = JwsToken<VCClaims>
