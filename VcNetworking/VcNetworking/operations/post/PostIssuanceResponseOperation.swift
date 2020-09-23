/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcJwt

public class PostIssuanceResponseOperation: InternalPostNetworkOperation {

    typealias Encoder = IssuanceResponseEncoder
    public typealias RequestBody = JwsToken<IssuanceResponseClaims>
    public typealias ResponseBody = VerifiableCredential
    
    let decoder = IssuanceServiceResponseDecoder()
    let encoder = IssuanceResponseEncoder()
    let urlSession: URLSession
    let urlRequest: URLRequest
    
    public init(withUrl urlStr: String, withBody body: JwsToken<IssuanceResponseClaims>, urlSession: URLSession = URLSession.shared) throws {
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.POST
        request.httpBody = try self.encoder.encode(value: body)
        request.setValue(Constants.PLAIN_TEXT, forHTTPHeaderField: Constants.CONTENT_TYPE)
        
        self.urlRequest = request
        self.urlSession = urlSession
    }
}

public typealias VerifiableCredential = JwsToken<VCClaims>
