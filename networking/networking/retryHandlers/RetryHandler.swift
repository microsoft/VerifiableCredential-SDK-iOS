//
//  GetNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import PromiseKit

protocol RetryHandler {
    
    var maxRetryCount: Int { get }

    func onRetry<ResponseBody>(closure : @escaping () -> Promise<ResponseBody>) -> Promise<ResponseBody>
}

extension RetryHandler {
    
    func onRetry<ResponseBody>(closure : @escaping () -> Promise<ResponseBody>) -> Promise<ResponseBody> {
        return Promise<ResponseBody> { seal in
            attempt(maximumRetryCount: self.maxRetryCount) {
                closure()
            }.done { responseBody in
                seal.fulfill(responseBody)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
