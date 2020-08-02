//
//  FetchContractNetworkOperationTests.swift
//  networkingTests
//
//  Created by Sydney Morton on 7/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest
import PromiseKit

@testable import networking

class FetchNetworkOperationTests: XCTestCase {
    
    override func setUp() {}
    
    func testSuccessfulFetchOperation() {
        
        let retryHandler = NoRetry()
        let foo = 5
        let expec = self.expectation(description: "Fire")
        
        retryHandler.attempt(maximumRetryCount: 3) {
            retryHandler.flakeyTask(parameters: foo)
        }.done { num in
            print(num)
            expec.fulfill()
        }.catch { error in
            print("here")
            print(error)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 10)
        
    }
}
