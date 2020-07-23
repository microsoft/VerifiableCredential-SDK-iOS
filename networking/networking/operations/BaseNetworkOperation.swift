//
//  BaseNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import PromiseKit

protocol BaseNetworkOperation {
    associatedtype T
    
    // var call: () -> Promise<T> { get }
    
    func fire(url: String) -> Promise<Swift.Result<T, Error>>
    
    func onSuccess() -> Promise<Swift.Result<T, Error>>
    
    func onFailure() throws
}
