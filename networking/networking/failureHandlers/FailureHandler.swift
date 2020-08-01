//
//  FailureHandler.swift
//  networking
//
//  Created by Sydney Morton on 7/31/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

protocol FailureHandler {
    func onFailure(data: Data, response: HTTPURLResponse) -> Swift.Result<Any, Error>
}
