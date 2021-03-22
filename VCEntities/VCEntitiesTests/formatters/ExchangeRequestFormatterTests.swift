/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCCrypto

@testable import VCEntities

class ExchangeRequestFormatterTests: XCTestCase {
    
    var formatter: ExchangeRequestFormatter!
    var mockRequest: ExchangeRequestContainer!
    var mockIdentifier: Identifier!
    var mockValidVc: VerifiableCredential!
    
    let expectedNewOwnerDid: String = "newOwnerDid235"
    
    override func setUpWithError() throws {
        let signer = MockTokenSigner(x: "x", y: "y")
        formatter = ExchangeRequestFormatter(signer: signer)
        
        let cryptoOperation = CryptoOperations(secretStore: SecretStoreMock())
        let key = try cryptoOperation.generateKey()
        
        mockValidVc = VerifiableCredential(from: TestData.verifiableCredential.rawValue)!
        
        let keyContainer = KeyContainer(keyReference: key, keyId: "keyId")
        mockIdentifier = Identifier(longFormDid: mockValidVc.content.sub, didDocumentKeys: [keyContainer], updateKey: keyContainer, recoveryKey: keyContainer, alias: "testAlias")
        
        mockRequest = try ExchangeRequestContainer(exchangeableVerifiableCredential: mockValidVc, newOwnerDid: expectedNewOwnerDid, currentOwnerIdentifier: mockIdentifier)
    }
    
    func testExchangeFormatter() throws {
        let actualExchangeRequest = try formatter.format(request: mockRequest)
        XCTAssertEqual(actualExchangeRequest.content.audience, mockRequest.audience)
        XCTAssertEqual(actualExchangeRequest.content.did, mockIdentifier.longFormDid)
        XCTAssertEqual(actualExchangeRequest.content.exchangeableVc, mockValidVc.rawValue)
        XCTAssertEqual(actualExchangeRequest.content.issuer, VCEntitiesConstants.SELF_ISSUED)
        XCTAssertEqual(actualExchangeRequest.content.recipientDid, expectedNewOwnerDid)
    }

}
