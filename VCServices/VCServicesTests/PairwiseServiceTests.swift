/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCEntities
import VCCrypto

@testable import VCServices

class PairwiseServiceTests: XCTestCase {
    
    var service: PairwiseService!
    var mockPresentationResponse: ResponseContaining!
    
    override func setUpWithError() throws {
        let formatter = MockExchangeRequestFormatter(shouldSucceed: true)
        let exchangeService = ExchangeService(formatter: formatter, apiCalls: MockExchangeApiCalls())
        
        service = PairwiseService(exchangeService: exchangeService,
                                  identifierService: IdentifierService())
        
        let requestToken = PresentationRequestToken(from: TestData.presentationRequest.rawValue)!
        let request = PresentationRequest(from: requestToken, linkedDomainResult: .linkedDomainVerified(domainUrl: "test.com"))
        self.mockPresentationResponse = try PresentationResponseContainer(from: request, expiryInSeconds: 5)
        
        let mockVc = VerifiableCredential(from: TestData.verifiableCredential.rawValue)!
        self.mockPresentationResponse.requestVCMap["test"] = mockVc
        
        MockIssuanceResponseFormatter.wasFormatCalled = false
        
        try self.storeMockOwnerIdentifier()
    }
    
    override func tearDownWithError() throws {
        try CoreDataManager.sharedInstance.deleteAllIdentifiers()
    }
    
    func testSendResponse() throws {
        let expec = self.expectation(description: "Fire")
        service.createPairwiseResponse(response: mockPresentationResponse).done {
            response in
            print(response)
            XCTFail()
            expec.fulfill()
        }.catch { error in
            print(error)
            XCTAssert(MockExchangeRequestFormatter.wasFormatCalled)
            XCTAssert(MockExchangeApiCalls.wasPostCalled)
            XCTAssert(error is MockExchangeNetworkingError)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 20)
    }
    
    private func storeMockOwnerIdentifier() throws {
        let identifierDB = IdentifierDatabase()
        let mockDid = "did:ion:EiAmVAdVaxoi6uxjUdGw-J2xbbsQE8SLFrtt3oz9CKEGgQ?-ion-initial-state=eyJkZWx0YV9oYXNoIjoiRWlBaE9zbHBNanZ6WFhfQS1ONEd6Szh6WVB4cE9XakJIakpMY252Si11aDJ0dyIsInJlY292ZXJ5X2NvbW1pdG1lbnQiOiJFaUFtT1JVelQtZGNlT3lOT0Vrc0Z6Wm9ZVV85Mm9yNl81cWN4N3UyMmtNa25BIn0.eyJ1cGRhdGVfY29tbWl0bWVudCI6IkVpQW1PUlV6VC1kY2VPeU5PRWtzRnpab1lVXzkyb3I2XzVxY3g3dTIya01rbkEiLCJwYXRjaGVzIjpbeyJhY3Rpb24iOiJyZXBsYWNlIiwiZG9jdW1lbnQiOnsicHVibGljX2tleXMiOlt7ImlkIjoieTZnX3NpZ25feE02Zy1vQllfMSIsInR5cGUiOiJFY2RzYVNlY3AyNTZrMVZlcmlmaWNhdGlvbktleTIwMTkiLCJqd2siOnsia3R5IjoiRUMiLCJjcnYiOiJzZWNwMjU2azEiLCJ4IjoicDI5emFHNktJT1otX3hxZkdBR3VjcDNCVm5BQ28xMDhsaXlVMWpGSlJmbyIsInkiOiI0X3EzWHlPUHJrWlRwUWhRaTdEM2N6RWM4OGd4VlpOOFNaZU5EQzZlUHJjIn0sInB1cnBvc2UiOlsiYXV0aCIsImdlbmVyYWwiXX1dfX1dfQ"
        let operations = CryptoOperations()
        let key = try operations.generateKey()
        let keyContainer = KeyContainer(keyReference: key, keyId: "test")
        let mockOwnerIdentifier = Identifier(longFormDid: mockDid, didDocumentKeys: [keyContainer], updateKey: keyContainer, recoveryKey: keyContainer, alias: "test")
        try identifierDB.saveIdentifier(identifier: mockOwnerIdentifier)
    }
}
