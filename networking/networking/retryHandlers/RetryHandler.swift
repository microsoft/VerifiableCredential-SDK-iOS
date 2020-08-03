//
//  GetNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import PromiseKit

protocol RetryHandler {

    func onRetry<ResponseBody>(closure : @escaping () -> Promise<ResponseBody>) -> Promise<ResponseBody>
}
