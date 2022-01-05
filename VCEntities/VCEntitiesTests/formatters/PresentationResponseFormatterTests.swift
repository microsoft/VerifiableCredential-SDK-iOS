/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCToken
import VCCrypto

@testable import VCEntities

class PresentationResponseFormatterTests: XCTestCase {
    
    var formatter: PresentationResponseFormatter!
    var mockRequest: PresentationRequest!
    var mockResponse: PresentationResponseContainer!
    var mockIdentifier: Identifier!
    let expectedContractUrl = "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert"
    let expectedCredentialType = "test435"
    let testHeader = Header(type: "testType", algorithm: "testAlg", jsonWebKey: "testWebKey", keyId: "testKid")
    
    override func setUpWithError() throws {
        let signer = MockTokenSigner(x: "x", y: "y")
        self.formatter = PresentationResponseFormatter(signer: signer)

        self.mockRequest = createExpectedPresentationRequest()
        self.mockResponse = try PresentationResponseContainer(from: mockRequest)
        
        let cryptoOperation = CryptoOperations(secretStore: SecretStoreMock())
        let key = try cryptoOperation.generateKey()
        
        let keyContainer = KeyContainer(keyReference: key, keyId: "keyId")
        self.mockIdentifier = Identifier(longFormDid: "longFormDid", didDocumentKeys: [keyContainer], updateKey: keyContainer, recoveryKey: keyContainer, alias: "testAlias")
    }
    
    func testFormatToken() throws {
        let vcClaims = VCClaims(jti: "testJti",
                                iss: "testIssuer",
                                sub: "testSubject",
                                iat: nil,
                                exp: nil,
                                vc: nil)
        self.mockResponse.requestVCMap[expectedCredentialType] = VerifiableCredential(headers: testHeader,
                                                                                      content: vcClaims,
                                                                                      rawValue: "testRawValue")
        
        let formattedToken = try formatter.format(response: self.mockResponse, usingIdentifier: self.mockIdentifier)
        
        XCTAssertEqual(formattedToken.content.did, self.mockIdentifier.longFormDid)
        XCTAssertNotNil(formattedToken.content.exp)
        XCTAssertNotNil(formattedToken.content.iat)
        XCTAssertNotNil(formattedToken.content.jti)
        XCTAssertEqual(formattedToken.content.audience, self.mockResponse.audienceUrl)
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
        XCTAssertEqual(formattedToken.content.did, self.mockIdentifier.longFormDid)
        XCTAssertNotNil(formattedToken.content.exp)
        XCTAssertNotNil(formattedToken.content.iat)
        XCTAssertNotNil(formattedToken.content.jti)
        XCTAssertEqual(formattedToken.content.audience, self.mockResponse.audienceUrl)
        XCTAssertNil(formattedToken.content.attestations)
        XCTAssertNil(formattedToken.content.presentationSubmission)
        XCTAssert(MockTokenSigner.wasSignCalled)
        XCTAssert(MockTokenSigner.wasGetPublicJwkCalled)
    }
    
    func createExpectedPresentationRequest() -> PresentationRequest? {
        let claims = PresentationRequestClaims(clientID: "testClientID",
                                               issuer: "testRequester",
                                               redirectURI: "testRedirectURI",
                                               responseMode: "testResponseMode",
                                               responseType: "testResponseType",
                                               claims: nil,
                                               state: "testState",
                                               nonce: "testNonce",
                                               scope: nil,
                                               prompt: nil,
                                               registration: nil,
                                               idTokenHint: nil,
                                               iat: nil,
                                               exp: nil)
        let testHeader = Header(type: "testType", algorithm: "testAlg", jsonWebKey: "testWebKey", keyId: "testKid")
        let token = PresentationRequestToken(headers: testHeader, content: claims)!
        let request = PresentationRequest(from: token, linkedDomainResult: .linkedDomainMissing)
        return request
    }
}
