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
import VcJwt

@testable import VCUseCase

class IssuanceUseCaseTests: XCTestCase {
    
    var usecase: IssuanceUseCase!
    var contract: Contract!
    let expectedUrl = "https://test3523.com"

    override func setUpWithError() throws {
        let repo = IssuanceRepository(apiCalls: MockApiCalls())
        let formatter = MockIssuanceResponseFormatter()
        self.usecase = IssuanceUseCase(formatter: formatter, repo: repo)
        
        let encodedContract = TestData.contract.rawValue.data(using: .utf8)!
        self.contract = try JSONDecoder().decode(Contract.self, from: encodedContract)
    }

    func testGetRequest() throws {
        let expec = self.expectation(description: "Fire")
        usecase.getRequest(usingUrl: expectedUrl).done {
            request in
            print(request)
            expec.fulfill()
        }.catch { error in
            print(error)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testSendResponse() throws {
        let expec = self.expectation(description: "Fire")
        let repo = IssuanceRepository(apiCalls: MockApiCalls())
        let formatter = MockIssuanceResponseFormatter()
        let usecase = IssuanceUseCase(formatter: formatter, repo: repo)
        let signedToken = JwsToken<IssuanceResponseClaims>(headers: Header(), content: IssuanceResponseClaims())
        usecase.send(token: signedToken).done {
            response in
            print(response)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            print(error)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 20)
    }

}
