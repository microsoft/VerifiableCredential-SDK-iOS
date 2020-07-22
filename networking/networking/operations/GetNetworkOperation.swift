//
//  GetNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

protocol GetNetworkOperation: BaseNetworkOperation {}

extension GetNetworkOperation {
    func onSuccess() {}
    func onFailure() {}
}
