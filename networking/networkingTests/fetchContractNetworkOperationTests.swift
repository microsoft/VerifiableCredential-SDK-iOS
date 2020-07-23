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
    let apiURL = URL(string: "https://testcontract.com/423")!
    
    override func setUp() {
      let configuration = URLSessionConfiguration.default
      configuration.protocolClasses = [UrlProtocolMock.self]
      let urlSession = URLSession.init(configuration: configuration)
      
        fetchContractApi = FetchContractNetworkOperation(urlSession: urlSession, url: apiURL)
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
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        let expec = self.expectation(description: "Fire")
        
        fetchContractApi.fire().done { result in
            print(result)
            expec.fulfill()
        }.catch { error in
            print(error)
        }
        
        wait(for: [expec], timeout: 5)
    }
    

}
