/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public protocol IssuanceRequestValidating {
    func validate(request: SignedContract, usingKeys publicKeys: [IdentifierDocumentPublicKey]) throws
}

public struct IssuanceRequestValidator: IssuanceRequestValidating {
    
    private let verifier: TokenVerifying
    
    public init(verifier: TokenVerifying = Secp256k1Verifier()) {
        self.verifier = verifier
    }
    
    public func validate(request: SignedContract, usingKeys publicKeys: [IdentifierDocumentPublicKey]) throws {
        
        for key in publicKeys {
            do {
                if try request.verify(using: verifier, withPublicKey: key.publicKeyJwk) {
                    return
                }
            } catch {
                // TODO: log error
            }
        }
        
        throw PresentationRequestValidatorError.invalidSignature
    }
    
}
