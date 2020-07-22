//
//  BaseNetworkOperation.swift
//  networking
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

protocol BaseNetworkOperation {
    associatedtype T
    
    func fire(url: String) -> T
    
    func onSuccess() -> T
    
    func onFailure() throws
}
