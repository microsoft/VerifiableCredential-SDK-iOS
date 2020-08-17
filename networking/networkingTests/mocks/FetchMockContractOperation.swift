/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import PromiseKit
import Serialization
@testable import networking

final public class FetchMockContractOperation: NetworkOperation {
    public typealias ResponseBody = MockContract
    
    public let retryHandler: RetryHandler  = NoRetry()
    public var successHandler: SuccessHandler = SimpleSuccessHandler()
    public let failureHandler: FailureHandler = SimpleFailureHandler()
    public let urlSession: URLSession
    public let urlRequest: URLRequest
    
    public init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.urlSession = session
    }
}
