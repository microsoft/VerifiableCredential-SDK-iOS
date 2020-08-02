//
//  FetchContractOperation.swift
//  networking
//
//  Created by Sydney Morton on 8/1/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

final class FetchContractOperation: NetworkOperation {
    typealias ResponseBody = Contract
    
    var retryHandler: RetryHandler
    var successHandler: SuccessHandler
    var failureHandler: FailureHandler
    var urlSession: URLSession
    var urlRequest: URLRequest
    
    init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.successHandler = SimpleSuccessHandler()
        self.failureHandler = SimpleFailureHandler()
        self.retryHandler = NoRetry()
        self.urlSession = session
    }
}
