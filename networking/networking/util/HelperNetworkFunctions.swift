//
//  HelperNetworkFunctions.swift
//  networking
//
//  Created by Sydney Morton on 8/2/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

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
