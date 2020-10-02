/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCJwt

@testable import VCEntities

class PresentationResponseFormatterTests: XCTestCase {
    
    var formatter: PresentationResponseFormatter!
    var request: PresentationRequest!
    var mockResponse: PresentationResponseContainer!
    var mockIdentifier: MockIdentifier!
    let expectedContractUrl = "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert"
    
    override func setUpWithError() throws {
        let signer = MockTokenSigner(x: "x", y: "y")
        self.formatter = PresentationResponseFormatter(signer: signer)
        
        let encodedRequest = TestData.presentationRequest.rawValue.data(using: .utf8)!
        self.request = JwsToken(from: encodedRequest)
        print(self.request.content.redirectURI)
        
        let vc = VerifiableCredential(from: TestData.verifiableCredential.rawValue)
        
        self.mockResponse = try PresentationResponseContainer(from: self.request)
        self.mockResponse.requestVCMap["test"] = vc
        
        self.mockIdentifier = MockIdentifier()
    }
    
    func testFormatToken() throws {
        let formattedToken = try formatter.format(response: self.mockResponse, usingIdentifier: self.mockIdentifier)
        XCTAssertEqual(formattedToken.content.did, self.mockIdentifier.id)
        XCTAssertEqual(formattedToken.content.audience, self.mockResponse.audience)
        XCTAssert(MockTokenSigner.wasSignCalled)
        XCTAssert(MockTokenSigner.wasGetPublicJwkCalled)
    }
    
    func testRequest() throws {
        let result = try self.formatter.format(response: self.mockResponse, usingIdentifier: self.mockIdentifier)
        print(try result.serialize())
    }
    
}
