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
    let expectedCredentialType = "test435"
    
    override func setUpWithError() throws {
        let signer = MockTokenSigner(x: "x", y: "y")
        self.formatter = PresentationResponseFormatter(signer: signer)
        
        let encodedRequest = TestData.presentationRequest.rawValue.data(using: .utf8)!
        self.request = JwsToken(from: encodedRequest)
        
        self.mockResponse = try PresentationResponseContainer(from: self.request)
        
        self.mockIdentifier = MockIdentifier()
    }
    
    func testFormatToken() throws {
        let vc = VerifiableCredential(from: TestData.verifiableCredential.rawValue)
        self.mockResponse.requestVCMap[expectedCredentialType] = vc
        
        let formattedToken = try formatter.format(response: self.mockResponse, usingIdentifier: self.mockIdentifier)
        
        XCTAssertEqual(formattedToken.content.did, self.mockIdentifier.id)
        XCTAssertNotNil(formattedToken.content.exp)
        XCTAssertNotNil(formattedToken.content.iat)
        XCTAssertNotNil(formattedToken.content.jti)
        XCTAssertEqual(formattedToken.content.audience, self.mockResponse.audience)
        XCTAssertNotNil(formattedToken.content.attestations!.presentations!.first!.value)
        XCTAssertEqual(formattedToken.content.attestations!.presentations!.first!.key, expectedCredentialType)
        XCTAssertEqual(formattedToken.content.presentationSubmission!.submissionDescriptors.first!.id, expectedCredentialType)
        XCTAssertEqual(formattedToken.content.presentationSubmission!.submissionDescriptors.first!.id, expectedCredentialType)
        XCTAssertEqual(formattedToken.content.presentationSubmission!.submissionDescriptors.first!.path, "$.attestations.presentations." + expectedCredentialType)
        XCTAssertEqual(formattedToken.content.presentationSubmission!.submissionDescriptors.first!.encoding, "base64Url")
        XCTAssertEqual(formattedToken.content.presentationSubmission!.submissionDescriptors.first!.format, "JWT")
        XCTAssert(MockTokenSigner.wasSignCalled)
        XCTAssert(MockTokenSigner.wasGetPublicJwkCalled)
    }
    
    func testFormatTokenNoVcs() throws {

        let formattedToken = try formatter.format(response: self.mockResponse, usingIdentifier: self.mockIdentifier)
        XCTAssertEqual(formattedToken.content.did, self.mockIdentifier.id)
        XCTAssertNotNil(formattedToken.content.exp)
        XCTAssertNotNil(formattedToken.content.iat)
        XCTAssertNotNil(formattedToken.content.jti)
        XCTAssertEqual(formattedToken.content.audience, self.mockResponse.audience)
        XCTAssertNil(formattedToken.content.attestations)
        XCTAssertNil(formattedToken.content.presentationSubmission)
        XCTAssert(MockTokenSigner.wasSignCalled)
        XCTAssert(MockTokenSigner.wasGetPublicJwkCalled)
    }
}
