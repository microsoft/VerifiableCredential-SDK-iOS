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

//class PostIssuanceResponseTests: XCTestCase {
//    private var postContractApi: PostIssuanceResponseOperation!
//    private let expectedUrl = "https://testcontract.com/4235"
//    private let expectedHttpResponse = "testPresentationResponse29384"
//    private let testRequestBody = "requestBody2543"
//    
//    override func setUp() {
//        let configuration = URLSessionConfiguration.default
//        configuration.protocolClasses = [UrlProtocolMock.self]
//        let urlSession = URLSession.init(configuration: configuration)
//        do {
//            postContractApi = try PostIssuanceResponseOperation(withUrl: self.expectedUrl, withBody: testRequestBody, urlSession: urlSession)
//        } catch {
//            print(error)
//        }
//    }
//    
//    func testSuccessfulPostOperation() {
//        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 200)
//        let expec = self.expectation(description: "Fire")
//
//        postContractApi.fire().done { result in
//            print(result)
//            switch result {
//            case .success(let response):
//                print(response)
//                XCTAssertEqual(response, self.expectedHttpResponse)
//            case .failure(_):
//                XCTFail()
//            }
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//        wait(for: [expec], timeout: 5)
//    }
//    
//    func testFailedPostOperation() {
//        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: self.expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 400)
//        let expec = self.expectation(description: "Fire")
//        
//        postContractApi.fire().done { result in
//            print(result)
//            switch result {
//            case .success(let contract):
//                print(contract)
//                XCTFail()
//            case .failure(let error):
//                XCTAssertEqual(error as! NetworkingError, NetworkingError.badRequest(withBody: self.expectedHttpResponse))
//            }
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//        wait(for: [expec], timeout: 5)
//    }
//    
//    func testInvalidUrlInput() {
//        let invalidUrl = ""
//        XCTAssertThrowsError(try PostIssuanceResponseOperation(withUrl: invalidUrl, withBody: "testResponse")) { error in
//            XCTAssertEqual(error as! NetworkingError, NetworkingError.invalidUrl(withUrl: invalidUrl))
//        }
//    }
//}
