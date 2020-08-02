//
//  GetNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import PromiseKit

protocol RetryHandler {    
    func onRetry<T>(closure : @escaping () -> Promise<T>) -> Promise<T>
}

extension RetryHandler {
    func attempt<T>(maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            print("attempt: \(attempts)")
            return body().recover { error -> Promise<T> in
                print("recover")
                print(error)
                guard attempts < maximumRetryCount else {
                    throw error
                }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }
    
    func onRetry<T>(closure : @escaping () -> Promise<T>) -> Promise<T> {
        return Promise<T> { seal in
            self.attempt {
                closure()
            }.done { num in
                seal.fulfill(num)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func flakeyTask(parameters: Int) -> Promise<Int> {
        return Promise<Int> { seal in
            if (parameters == 4) {
                seal.fulfill(parameters)
            } else {
                seal.reject(NetworkingError.unknownNetworkingError(withBody: String(parameters)))
            }
        }
    }
}
