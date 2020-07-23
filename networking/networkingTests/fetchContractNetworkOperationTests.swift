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
    var fetchContractApi: FetchContractNetworkOperation!
    var expectation: XCTestExpectation!
    let testUrl = "https://testcontract.com/423"
    
    override func setUp() {
      let configuration = URLSessionConfiguration.default
      configuration.protocolClasses = [UrlProtocolMock.self]
      let urlSession = URLSession.init(configuration: configuration)
      fetchContractApi = FetchContractNetworkOperation(urlSession: urlSession)
        do {
            try fetchContractApi.createRequest(withUrl: testUrl)
            fetchContractApi.addSerializer(serializer: MockSerializer())
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
    

}
