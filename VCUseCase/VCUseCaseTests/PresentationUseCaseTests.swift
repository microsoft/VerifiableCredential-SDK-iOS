/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCRepository
import VCEntities

@testable import VCUseCase

class PresentationUseCaseTests: XCTestCase {
    
    var usecase: PresentationUseCase!
    var presentationRequest: PresentationRequest!
    var mockIdentifier: Identifier!
    let expectedUrl = "openid://vc/?request_uri=https://test-relyingparty.azurewebsites.net/request/UZWlr4uOY13QiA"
    
    override func setUpWithError() throws {
        let repo = PresentationRepository(apiCalls: MockApiCalls())
        let formatter = PresentationResponseFormatter()
        self.usecase = PresentationUseCase(formatter: formatter, repo: repo)
        
        self.presentationRequest = PresentationRequest(from: TestData.presentationRequest.rawValue)!
        
        let keyContainer = KeyContainer(keyReference: MockVCCryptoSecret(), keyId: "keyId234")
         self.mockIdentifier = Identifier(longformId: "longform", didDocumentKeys: [keyContainer], updateKey: keyContainer, recoveryKey: keyContainer)
        
        MockPresentationResponseFormatter.wasFormatCalled = false
        MockApiCalls.wasPostCalled = false
        MockApiCalls.wasGetCalled = false
    }
    
    func testPublicInit() {
        let usecase = IssuanceUseCase()
        XCTAssertNotNil(usecase.formatter)
        XCTAssertNotNil(usecase.repo)
    }
    
    func testGetRequest() throws {
        let expec = self.expectation(description: "Fire")
        usecase.getRequest(usingUrl: expectedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTAssert(MockApiCalls.wasGetCalled)
            XCTAssert(error is MockError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testGetRequestMalformedUri() throws {
        let expec = self.expectation(description: "Fire")
        let malformedUrl = " "
        usecase.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is PresentationUseCaseError)
            XCTAssertEqual(error as? PresentationUseCaseError, .inputStringNotUri)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testGetRequestNoQueryParameters() throws {
        let expec = self.expectation(description: "Fire")
        let malformedUrl = "https://test.com"
        usecase.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is PresentationUseCaseError)
            XCTAssertEqual(error as? PresentationUseCaseError, .noQueryParametersOnUri)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testGetRequestNoValueOnRequestUri() throws {
        let expec = self.expectation(description: "Fire")
        let malformedUrl = "https://test.com?request_uri"
        usecase.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTAssert(error is PresentationUseCaseError)
            XCTAssertEqual(error as? PresentationUseCaseError, .noValueForRequestUriQueryParameter)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testGetRequestNoRequestUri() throws {
        let expec = self.expectation(description: "Fire")
        let malformedUrl = "https://test.com?testparam=33423"
        usecase.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is PresentationUseCaseError)
            XCTAssertEqual(error as? PresentationUseCaseError, .noRequestUriQueryParameter)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testSendResponse() throws {
        let expec = self.expectation(description: "Fire")
        
        let repo = PresentationRepository(apiCalls: MockApiCalls())
        let formatter = MockPresentationResponseFormatter(shouldSucceed: true)
        let usecase = PresentationUseCase(formatter: formatter, repo: repo)
        
        let response = try PresentationResponseContainer(from: self.presentationRequest)
        usecase.send(response: response, identifier: self.mockIdentifier).done {
            response in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTAssert(MockPresentationResponseFormatter.wasFormatCalled)
            XCTAssert(MockApiCalls.wasPostCalled)
            XCTAssert(error is MockError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 20)
    }
    
    func testSendResponseFailedToFormat() throws {
        let expec = self.expectation(description: "Fire")
        
        let repo = PresentationRepository(apiCalls: MockApiCalls())
        let formatter = MockPresentationResponseFormatter(shouldSucceed: false)
        let usecase = PresentationUseCase(formatter: formatter, repo: repo)
        
        let response = try PresentationResponseContainer(from: self.presentationRequest)
        usecase.send(response: response, identifier: self.mockIdentifier).done {
            response in
            XCTFail()
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTAssert(MockPresentationResponseFormatter.wasFormatCalled)
            XCTAssertFalse(MockApiCalls.wasPostCalled)
            XCTAssert(error is MockIssuanceResponseFormatterError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 20)
    }
}
