//
//  VCUseCaseTests.swift
//  VCUseCaseTests
//
//  Created by Sydney Morton on 9/14/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import XCTest
import VCRepository
import VcNetworking

@testable import VCUseCase

class IssuanceUseCaseTests: XCTestCase {
    
    var usecase: IssuanceUseCase!
    var contract: Contract!
    let expectedUrl = "https://test3523.com"

    override func setUpWithError() throws {
        let repo = IssuanceRepository(apiCalls: MockApiCalls())
        let formatter = IssuanceResponseFormatter(signer: MockTokenSigner())
        usecase = IssuanceUseCase(formatter: formatter, repo: repo)
        
        let encodedContract = TestData.contract.rawValue.data(using: .utf8)!
        self.contract = try JSONDecoder().decode(Contract.self, from: encodedContract)
    }
//
//    func testGetRequest() throws {
//        usecase.getRequest(usingUrl: expectedUrl)
//    }
    
    func testSendResponse() throws {
        let expec = self.expectation(description: "Fire")
        usecase.send(response: MockIssuanceResponse(from: self.contract, contractUri: self.expectedUrl)).done {
            response in
            print(response)
            expec.fulfill()
        }.catch { error in
            print(error)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }

}
