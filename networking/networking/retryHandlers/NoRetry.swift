//
//  NoRetry.swift
//  networking
//
//  Created by Sydney Morton on 8/1/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import PromiseKit

final class NoRetry: RetryHandler {

    func onRetry<ResponseBody>(closure : @escaping () -> Promise<ResponseBody>) -> Promise<ResponseBody> {
        return closure()
    }
}
