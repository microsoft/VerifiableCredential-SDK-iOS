//
//  NoRetry.swift
//  networking
//
//  Created by Sydney Morton on 8/1/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

final class NoRetry: RetryHandler {
    
    let maxRetryCount: Int = 0

    init() {}
}
