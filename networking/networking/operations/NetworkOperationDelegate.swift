//
//  NetworkOperationDelegate.swift
//  networking
//
//  Created by Sydney Morton on 7/23/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

protocol NetworkOperationDelegate {
    associatedtype T

    func onSuccess(data: Data) -> Swift.Result<T, Error>
    
    func onFailure(response: HTTPURLResponse) -> Swift.Result<T, Error>
}
