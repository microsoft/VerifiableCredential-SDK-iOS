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
    var successHandler: SuccessHandler
    var failureHandler: FailureHandler
    var urlSession: URLSession
    var urlRequest: URLRequest
    
    init() {}
    
    convenience init(withUrl urlStr: String, session: URLSession = URLSession.shared) throws {
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidUrl(withUrl: urlStr)
        }
        
        let urlRequest = URLRequest(url: url)
        let successHandler = SimpleSuccessHandler()
        let failureHandler = SimpleFailureHandler()
        self.init(request: urlRequest, successHandler: successHandler, failureHandler: failureHandler, session: session)
    }
}
