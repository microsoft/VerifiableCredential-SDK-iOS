/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

enum PresentationRequestValidatorError: Error {
    case noExpirationPresent
    case tokenExpired
    case invalidSignature
    case invalidScopeValue
    case invalidResponseTypeValue
    case invalidResponseModeValue
}

public struct PresentationRequestValidator {
    
    private let verifier: TokenVerifying
    
    init(verifier: TokenVerifying = Secp256k1Verifier()) {
        self.verifier = verifier
    }
    
    func validate(request: PresentationRequest, usingKeys publicKeys: [ECPublicJwk]) throws {
        try validate(token: request, using: publicKeys)
        try validate(expiration: request.content.exp)
        try validate(request.content.scope, equals: VCEntitiesConstants.SCOPE, throws: PresentationRequestValidatorError.invalidScopeValue)
        try validate(request.content.responseMode, equals: VCEntitiesConstants.RESPONSE_MODE, throws: PresentationRequestValidatorError.invalidResponseModeValue)
        try validate(request.content.responseType, equals: VCEntitiesConstants.RESPONSE_TYPE, throws: PresentationRequestValidatorError.invalidResponseTypeValue)
    }
    
    private func validate(token: PresentationRequest, using keys: [ECPublicJwk]) throws {
        
        for key in keys {
            do {
                if try token.verify(using: verifier, withPublicKey: key) {
                    return
                }
            } catch {
                // TODO: log error
            }
        }
        
        throw PresentationRequestValidatorError.invalidSignature
    }
    
    private func validate(expiration: Double?) throws {
        guard let exp = expiration else { throw PresentationRequestValidatorError.noExpirationPresent }
        if getExpirationDeadlineInSeconds() > exp { throw PresentationRequestValidatorError.tokenExpired }
    }
    
    private func validate(_ value: String?, equals correctValue: String, throws error: Error) throws {
        guard value == correctValue else { throw error }
    }
    
    private func getExpirationDeadlineInSeconds(expirationCheckTimeOffsetInSeconds: Int = 300) -> Double {
        let currentTimeInSeconds = (Date().timeIntervalSince1970).rounded(.down)
        return currentTimeInSeconds - Double(expirationCheckTimeOffsetInSeconds)
    }
}
