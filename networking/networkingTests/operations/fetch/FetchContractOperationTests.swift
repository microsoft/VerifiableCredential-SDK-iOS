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

class FetchContractTests: XCTestCase {
    private var fetchContractOperation: FetchContractOperation!
    private let expectedUrl = "https://testcontract.com/4235"
    private let expectedHttpResponse = "expectedHttpResponse324"
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        do {
            fetchContractOperation = try FetchContractOperation(withUrl: expectedUrl, session: urlSession)
        } catch {
            print(error)
        }
    }
    
    func testSuccessfulInit() {
        XCTAssertTrue(fetchContractOperation.successHandler is SimpleSuccessHandler)
        XCTAssertTrue(fetchContractOperation.failureHandler is SimpleFailureHandler)
        XCTAssertTrue(fetchContractOperation.retryHandler is NoRetry)
        XCTAssertEqual(fetchContractOperation.urlRequest.url!.absoluteString, expectedUrl)
    }
    
    func testInvalidUrlInit() {
        let invalidUrl = ""
        XCTAssertThrowsError(try FetchContractOperation(withUrl: invalidUrl)) { error in
            XCTAssertEqual(error as! NetworkingError, NetworkingError.invalidUrl(withUrl: invalidUrl))
        }
    }
    
    func testSuccessfulFetchOperation() {
        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 200)
        let expec = self.expectation(description: "Fire")
        
        fetchContractOperation.fire().done { response in
            print(response)
            XCTAssertEqual(response, self.expectedHttpResponse)
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
//
//    func testFailedFetchOperationUnauthorized() {
//        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 401)
//        let expec = self.expectation(description: "Fire")
//
//        fetchContractOperation.fire().done { result in
//            print(result)
//            switch result {
//            case .success(let contract):
//                print(contract)
//                XCTFail()
//            case .failure(let error):
//                XCTAssertEqual(error as! NetworkingError, NetworkingError.unauthorized(withBody: self.expectedHttpResponse))
//            }
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//        wait(for: [expec], timeout: 5)
//    }
//
//    func testFailedFetchOperationForbidden() {
//        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 403)
//        let expec = self.expectation(description: "Fire")
//
//        fetchContractOperation.fire().done { result in
//            print(result)
//            switch result {
//            case .success(let contract):
//                print(contract)
//                XCTFail()
//            case .failure(let error):
//                XCTAssertEqual(error as! NetworkingError, NetworkingError.forbidden(withBody: self.expectedHttpResponse))
//            }
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//        wait(for: [expec], timeout: 5)
//    }
//
//    func testFailedFetchOperationNotFound() {
//        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 404)
//        let expec = self.expectation(description: "Fire")
//
//        fetchContractOperation.fire().done { result in
//            print(result)
//            switch result {
//            case .success(let contract):
//                print(contract)
//                XCTFail()
//            case .failure(let error):
//                XCTAssertEqual(error as! NetworkingError, NetworkingError.notFound(withBody: self.expectedHttpResponse))
//            }
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//        wait(for: [expec], timeout: 5)
//    }
//
//    func testFailedFetchOperationServiceError() {
//        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 500)
//        let expec = self.expectation(description: "Fire")
//
//        fetchContractOperation.fire().done { result in
//            print(result)
//            switch result {
//            case .success(let contract):
//                print(contract)
//                XCTFail()
//            case .failure(let error):
//                XCTAssertEqual(error as! NetworkingError, NetworkingError.serverError(withBody: self.expectedHttpResponse))
//            }
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//        wait(for: [expec], timeout: 5)
//    }
//
//    func testFailedFetchOperationUnknownNetworkError() {
//        UrlProtocolMock.createMockResponse(httpResponse: self.expectedHttpResponse, url: expectedUrl, responseBody: self.expectedHttpResponse, statusCode: 600)
//        let expec = self.expectation(description: "Fire")
//
//        fetchContractOperation.fire().done { result in
//            print(result)
//            switch result {
//            case .success(let contract):
//                print(contract)
//                XCTFail()
//            case .failure(let error):
//                XCTAssertEqual(error as! NetworkingError, NetworkingError.unknownNetworkingError(withBody: self.expectedHttpResponse))
//            }
//            expec.fulfill()
//        }.catch { error in
//            print(error)
//            XCTFail()
//        }
//        wait(for: [expec], timeout: 5)
//    }
}
