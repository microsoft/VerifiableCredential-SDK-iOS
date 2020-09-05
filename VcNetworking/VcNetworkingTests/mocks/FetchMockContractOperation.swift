/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import PromiseKit
@testable import VcNetworking

final class FetchMockContractOperation: NetworkOperation {
    typealias SuccessHandler = SimpleSuccessHandler
    
    let retryHandler: RetryHandler  = NoRetry()
    var successHandler: SuccessHandler = SimpleSuccessHandler(decoder: MockDecoder())
    let failureHandler: FailureHandling = SimpleFailureHandler()
    let urlSession: URLSession
    let urlRequest: URLRequest
    
    public init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.urlSession = session
    }
}
