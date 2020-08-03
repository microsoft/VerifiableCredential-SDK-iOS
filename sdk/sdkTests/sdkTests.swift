//
//  sdkTests.swift
//  sdkTests
//
//  Created by Sydney Morton on 7/17/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest
import Networking
import Serialization

@testable import sdk

class sdkTests: XCTestCase {
    
    let serializer = Serializer()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let expec = self.expectation(description: "Fire")
        let fetch = try FetchContractOperation(withUrl: "https://portableidentitycards.azure-api.net/dev-v1.0/536279f6-15cc-45f2-be2d-61e352b51eef/portableIdentities/contracts/WoodgroveId")
        fetch.fire().done { result in
            print(result)
            expec.fulfill()
        }.catch { error in
            print(error)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
