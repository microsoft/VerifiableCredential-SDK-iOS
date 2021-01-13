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

let RESPONSE_TYPE = "id_token"
let RESPONSE_MODE = "form_post"
let SCOPE = "openid did_authn"

public struct PresentationRequestValidator {
    
    let verifier: TokenVerifying
    
    init(verifier: TokenVerifying = Secp256k1Verifier()) {
        self.verifier = verifier
    }
    
    func validate(request: PresentationRequest, usingKeys publicKeys: [ECPublicJwk]) throws {
        try verify(token: request, using: publicKeys)
        try check(expiration: request.content.exp)
        try check(value: request.content.scope, usingCorrectValue: SCOPE, error: PresentationRequestValidatorError.invalidScopeValue)
        try check(value: request.content.responseMode, usingCorrectValue: RESPONSE_MODE, error: PresentationRequestValidatorError.invalidResponseModeValue)
        try check(value: request.content.responseType, usingCorrectValue: RESPONSE_TYPE, error: PresentationRequestValidatorError.invalidResponseTypeValue)
    }
    
    private func verify(token: PresentationRequest, using keys: [ECPublicJwk]) throws {
        
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
    
    private func check(expiration: Double?) throws {
        guard let exp = expiration else { throw PresentationRequestValidatorError.noExpirationPresent }
        if getExpirationDeadlineInSeconds() > exp { throw PresentationRequestValidatorError.tokenExpired }
    }
    
    private func check(value: String?, usingCorrectValue correctValue: String, error: Error) throws {
        guard value == correctValue else { throw error }
    }
    
    private func getExpirationDeadlineInSeconds(expirationCheckTimeOffsetInSeconds: Int = 300) -> Double {
        let currentTimeInSeconds = (Date().timeIntervalSince1970).rounded(.down)
        return currentTimeInSeconds - Double(expirationCheckTimeOffsetInSeconds)
    }
    
    
}
