/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCRepository
import VCEntities

@testable import VCServices

class PresentationServiceTests: XCTestCase {
    
    var service: PresentationService!
    var presentationRequest: PresentationRequest!
    var mockIdentifier: Identifier!
    let identifierDB = IdentifierDatabase()
    let identifierCreator = IdentifierCreator()
    let expectedUrl = "openid://vc/?request_uri=https://test-relyingparty.azurewebsites.net/request/UZWlr4uOY13QiA"
    
    override func setUpWithError() throws {
        let repo = PresentationRepository(apiCalls: MockApiCalls())
        let formatter = PresentationResponseFormatter()
        let identifierService = IdentifierService()
        let pairwiseService = PairwiseService()
        service = PresentationService(formatter: formatter,
                                      repo: repo,
                                      identifierService: identifierService,
                                      pairwiseService: pairwiseService)
        
        self.presentationRequest = PresentationRequest(from: TestData.presentationRequest.rawValue)!
        
        self.mockIdentifier = try identifierCreator.create(forId: "master", andRelyingParty: "master")
        
        try identifierDB.saveIdentifier(identifier: mockIdentifier)
        
        MockPresentationResponseFormatter.wasFormatCalled = false
        MockApiCalls.wasPostCalled = false
        MockApiCalls.wasGetCalled = false
    }
    
    override func tearDownWithError() throws {
        try CoreDataManager.sharedInstance.deleteAllIdentifiers()
    }
    
    func testPublicInit() {
        let service = IssuanceService()
        XCTAssertNotNil(service.formatter)
        XCTAssertNotNil(service.repo)
    }
    
    func testGetRequest() throws {
        let expec = self.expectation(description: "Fire")
        service.getRequest(usingUrl: expectedUrl).done {
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
        service.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is PresentationServiceError)
            XCTAssertEqual(error as? PresentationServiceError, .inputStringNotUri)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testGetRequestNoQueryParameters() throws {
        let expec = self.expectation(description: "Fire")
        let malformedUrl = "https://test.com"
        service.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is PresentationServiceError)
            XCTAssertEqual(error as? PresentationServiceError, .noQueryParametersOnUri)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testGetRequestNoValueOnRequestUri() throws {
        let expec = self.expectation(description: "Fire")
        let malformedUrl = "https://test.com?request_uri"
        service.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTAssert(error is PresentationServiceError)
            XCTAssertEqual(error as? PresentationServiceError, .noValueForRequestUriQueryParameter)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testGetRequestNoRequestUri() throws {
        let expec = self.expectation(description: "Fire")
        let malformedUrl = "https://test.com?testparam=33423"
        service.getRequest(usingUrl: malformedUrl).done {
            request in
            print(request)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            XCTAssert(error is PresentationServiceError)
            XCTAssertEqual(error as? PresentationServiceError, .noRequestUriQueryParameter)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 5)
    }
    
    func testSendResponse() throws {
        let expec = self.expectation(description: "Fire")
        
        let repo = PresentationRepository(apiCalls: MockApiCalls())
        let formatter = MockPresentationResponseFormatter(shouldSucceed: true)
        let pairwiseService = PairwiseService()
        let identifierService = IdentifierService()
        let service = PresentationService(formatter: formatter,
                                          repo: repo,
                                          identifierService: identifierService,
                                          pairwiseService: pairwiseService)
        
        let response = try PresentationResponseContainer(from: self.presentationRequest)
        service.send(response: response).done {
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
        let identifierService = IdentifierService()
        let pairwiseService = PairwiseService()
        let service = PresentationService(formatter: formatter,
                                      repo: repo,
                                      identifierService: identifierService,
                                      pairwiseService: pairwiseService)
        
        let response = try PresentationResponseContainer(from: self.presentationRequest)
        service.send(response: response).done {
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
