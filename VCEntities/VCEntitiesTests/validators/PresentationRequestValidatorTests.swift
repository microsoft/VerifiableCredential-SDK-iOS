/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCCrypto
import VCToken

@testable import VCEntities

class PresentationRequestValidatorTests: XCTestCase {
    
    let verifier: TokenVerifying = MockTokenVerifier(isTokenValid: true)
    let mockPublicKey = ECPublicJwk(x: "x", y: "y", keyId: "keyId")
    var mockDidPublicKey: IdentifierDocumentPublicKey!
    
    override func setUpWithError() throws {
        mockDidPublicKey = IdentifierDocumentPublicKey(id: "test",
                                                       type: "Typetest",
                                                       controller: "controllerTest",
                                                       publicKeyJwk: mockPublicKey,
                                                       purposes: ["purpose"])
    }
    
    override func tearDownWithError() throws {
        MockTokenVerifier.wasVerifyCalled = false
    }
    
    func testShouldBeValid() throws {
        let validator = PresentationRequestValidator(verifier: verifier)
        let mockRequestClaims = createMockPresentationRequestClaims()
        if let mockRequest = PresentationRequestToken(headers: Header(),content: mockRequestClaims) {
            try validator.validate(request: mockRequest, usingKeys: [mockDidPublicKey])
            XCTAssertTrue(MockTokenVerifier.wasVerifyCalled)
        }
    }
    
    func testInvalidScopeValue() throws {
        let validator = PresentationRequestValidator(verifier: verifier)
        let mockRequestClaims = createMockPresentationRequestClaims(scope: "wrongValue")
        if let mockRequest = PresentationRequestToken(headers: Header(),content: mockRequestClaims) {
            XCTAssertThrowsError(try validator.validate(request: mockRequest, usingKeys: [mockDidPublicKey])) { error in
                XCTAssertEqual(error as? PresentationRequestValidatorError, PresentationRequestValidatorError.invalidScopeValue)
            }
            XCTAssertTrue(MockTokenVerifier.wasVerifyCalled)
        }
    }
    
    func testInvalidResponseTypeValue() throws {
        let validator = PresentationRequestValidator(verifier: verifier)
        let mockRequestClaims = createMockPresentationRequestClaims(responseType: "wrongValue")
        if let mockRequest = PresentationRequestToken(headers: Header(),content: mockRequestClaims) {
            XCTAssertThrowsError(try validator.validate(request: mockRequest, usingKeys: [mockDidPublicKey])) { error in
                XCTAssertEqual(error as? PresentationRequestValidatorError, PresentationRequestValidatorError.invalidResponseTypeValue)
            }
            XCTAssertTrue(MockTokenVerifier.wasVerifyCalled)
        }
    }
    
    func testInvalidResponseModeValue() throws {
        let validator = PresentationRequestValidator(verifier: verifier)
        let mockRequestClaims = createMockPresentationRequestClaims(responseMode: "wrongValue")
        if let mockRequest = PresentationRequestToken(headers: Header(),content: mockRequestClaims) {
            XCTAssertThrowsError(try validator.validate(request: mockRequest, usingKeys: [mockDidPublicKey])) { error in
                XCTAssertEqual(error as? PresentationRequestValidatorError, PresentationRequestValidatorError.invalidResponseModeValue)
            }
            XCTAssertTrue(MockTokenVerifier.wasVerifyCalled)
        }
    }
    
    func testExpiredTokenError() throws {
        let validator = PresentationRequestValidator(verifier: verifier)
        let mockRequestClaims = createMockPresentationRequestClaims(timeConstraints: TokenTimeConstraints(expiryInSeconds: -500))
        if let mockRequest = PresentationRequestToken(headers: Header(),content: mockRequestClaims) {
            XCTAssertThrowsError(try validator.validate(request: mockRequest, usingKeys: [mockDidPublicKey])) { error in
                XCTAssertEqual(error as? PresentationRequestValidatorError, PresentationRequestValidatorError.tokenExpired)
            }
            XCTAssertTrue(MockTokenVerifier.wasVerifyCalled)
        }
    }
    
    func testClockSkewLeewayForExpirationCheck() throws {
        let validator = PresentationRequestValidator(verifier: verifier)
        let mockRequestClaims = createMockPresentationRequestClaims(timeConstraints: TokenTimeConstraints(expiryInSeconds: -200))
        if let mockRequest = PresentationRequestToken(headers: Header(),content: mockRequestClaims) {
            try validator.validate(request: mockRequest, usingKeys: [mockDidPublicKey])
            XCTAssertTrue(MockTokenVerifier.wasVerifyCalled)
        }
    }
    
    private func createMockPresentationRequestClaims(responseType: String = VCEntitiesConstants.RESPONSE_TYPE,
                                                     responseMode: String = VCEntitiesConstants.RESPONSE_MODE,
                                                     scope: String = VCEntitiesConstants.SCOPE,
                                                     timeConstraints: TokenTimeConstraints = TokenTimeConstraints(expiryInSeconds: 300)) -> PresentationRequestClaims {
        let presentationDefinition = PresentationDefinition(inputDescriptors: [])
        return PresentationRequestClaims(clientID: "clientID",
                                         issuer: "issuer",
                                         redirectURI: "redirectURI",
                                         responseMode: responseMode,
                                         responseType: responseType,
                                         presentationDefinition: presentationDefinition,
                                         state: "state",
                                         nonce: "nonce",
                                         scope: scope,
                                         prompt: "create",
                                         registration: nil,
                                         idTokenHint: nil,
                                         iat: timeConstraints.issuedAt,
                                         exp: timeConstraints.expiration)
    }
    
}
