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

class FetchContractNetworkOperationTests: XCTestCase {
    var fetchContractApi: FetchNetworkOperation<MockedContract>!
    var expectation: XCTestExpectation!
    let testUrl = "https://testcontract.com/4235"
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        do {
            fetchContractApi = try FetchContractNetworkOperation(withUrl: testUrl, urlSession: urlSession)
        } catch {
            print(error)
        }
    }
    
    func testSuccessfulFetchOperation() {
        let jsonString = """
                            {
                            "id": "test23",
                            "type": "type235"
                            }
                         """
        let data = jsonString.data(using: .utf8)
        UrlProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: self.testUrl)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
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
        let jsonString = """
                            {
                            "id": "test23",
                            "type": "type235"
                            }
                         """
        let data = jsonString.data(using: .utf8)
        UrlProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: self.testUrl)!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
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
        let jsonString = """
                            {
                            "id": "test23",
                            "tye": "type235"
                            }
                         """
        let data = jsonString.data(using: .utf8)
        UrlProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: self.testUrl)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
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
    
    
}
