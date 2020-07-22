//
//  GetNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

protocol Retryable {
    associatedtype T
    
    func onRetry() -> T
}
