//
//  NoRetryTests.swift
//  networkingTests
//
//  Created by Sydney Morton on 8/3/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest
import PromiseKit

class NoRetryTests: XCTestCase {
    
    let noRetry = NoRetry()
    var expectedClosureCalled = false
    let expectedAnswer = 425

    func testNoRetry() throws {
        let expec = self.expectation(description: "Fire")
        noRetry.onRetry(closure: expectedClosure).done { actualNum in
            XCTAssertEqual(actualNum, self.expectedAnswer)
            XCTAssertTrue(self.expectedClosureCalled)
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func expectedClosure() -> Promise<Int> {
        return Promise<Int> { seal in
            self.expectedClosureCalled = true
            seal.fulfill(self.expectedAnswer)
        }
    }

}
