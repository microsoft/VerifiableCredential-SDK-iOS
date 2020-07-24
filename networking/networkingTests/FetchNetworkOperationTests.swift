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
    var fetchContractApi: FetchNetworkOperation<MockedContract>!
    var expectation: XCTestExpectation!
    let testUrl = "https://testcontract.com/4235"
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        let urlRequest = URLRequest(url: URL(string: testUrl)!)
        fetchContractApi = FetchNetworkOperation(urlRequest: urlRequest, serializer: Serializer(), urlSession: urlSession)
    }
    
    func testSuccessfulFetchOperation() {
        self.createMockResponse(responseBody: self.expectedStringifiedContract, statusCode: 200)
        let expec = self.expectation(description: "Fire")
        
        fetchContractApi.fire().done { result in
            print(result)
            switch result {
            case .success(let contract):
                print(contract)
                XCTAssertEqual(contract.id, "test23")
                XCTAssertEqual(contract.type, "type235")
            case .failure(let error):
                XCTAssertTrue(error is NetworkingError)
                XCTFail()
            }
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testFailedFetchOperation() {
        self.createMockResponse(responseBody: self.expectedStringifiedContract, statusCode: 400)
        let expec = self.expectation(description: "Fire")
        
        fetchContractApi.fire().done { result in
            print(result)
            switch result {
            case .success(let contract):
                print(contract)
                XCTFail()
            case .failure(let error):
                XCTAssertTrue(error is NetworkingError)
            }
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testFetchOperationWithInvalidJSON() {
        let expectedResponseBody = """
                            {
                            "id": "test23",
                            "invalidKey": "type235"
                            }
                         """
        self.createMockResponse(responseBody: expectedResponseBody, statusCode: 200)
        
        let expec = self.expectation(description: "Fire")
        
        fetchContractApi.fire().done { result in
            switch result {
            case .success(let contract):
                print(contract)
                XCTFail()
            case .failure(let error):
                print(error)
                XCTAssertTrue(error is DecodingError)
            }
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    private func createMockResponse(responseBody: String, statusCode: Int) {
        let data = responseBody.data(using: .utf8)
        UrlProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: self.testUrl)!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    private let expectedStringifiedContract =
    """
        {
          "id": "test23",
          "type": "type235"
        }
    """
    
    
}
