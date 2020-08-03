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
    
    let retryHandler: RetryHandler  = NoRetry()
    let successHandler: SuccessHandler = SimpleSuccessHandler()
    let failureHandler: FailureHandler = SimpleFailureHandler()
    let urlSession: URLSession
    let urlRequest: URLRequest
    
    init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        self.urlRequest = URLRequest(url: url)
        self.urlSession = session
    }
}
