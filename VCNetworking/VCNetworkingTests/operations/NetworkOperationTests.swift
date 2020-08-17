//
//  File.swift
//  networkingTests
//
//  Created by Sydney Morton on 8/17/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
import XCTest
import PromiseKit

@testable import networking

class NetworkOperationTests: XCTestCase {
    private var fetchContractOperation: FetchMockContractOperation!
    private let expectedUrl = "https://testcontract.com/4235"
    private let expectedHttpResponse = "expectedHttpResponse324"
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        do {
            fetchContractOperation = try FetchMockContractOperation(withUrl: expectedUrl, session: urlSession)
        } catch {
            print(error)
        }
    }
    
    func testSuccessfulFetchOperation() {
        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 200)
        let expec = self.expectation(description: "Fire")
        
        fetchContractOperation.fire().done { response in
            print(response)
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTFail()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testFailedFetchOperationBadRequestBody() {
        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 400)
        let expec = self.expectation(description: "Fire")

        fetchContractOperation.fire().done { response in
            print(response)
            expec.fulfill()
            XCTFail()
        }.catch { error in
            print(error)
            XCTAssertEqual(error as! NetworkingError, NetworkingError.badRequest(withBody: self.expectedHttpResponse))
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 10)
    }
    
}
