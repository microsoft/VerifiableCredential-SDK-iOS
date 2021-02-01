/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

enum DomainLinkageCredentialValidatorError: Error {
    case invalidSignature
    case tokenExpired
    case invalidDomainLinkageCredentialIssuerInWellKnownDocument
    case invalidDomainLinkageCredentialSubjectInWellKnownDocument
    case invalidCredentialSubjectIdentifierInWellKnownDocument
    case credentialSubjectOriginInvalid
}

public protocol DomainLinkageCredentialValidating {
    func validate(from input: DomainLinkageVerificationInput) throws
}

public struct DomainLinkageCredentialValidator: DomainLinkageCredentialValidating {
    
    private let verifier: TokenVerifying
    
    public init(verifier: TokenVerifying = Secp256k1Verifier()) {
        self.verifier = verifier
    }
    
    public func validate(from input: DomainLinkageVerificationInput) throws {
        try validate(token: input.credential, using: input.document.verificationMethod)
        try validate(input.credential.content.issuer,
                     equals: input.credential.content.verifiableCredential.credentialSubject.did,
                     throws: DomainLinkageCredentialValidatorError.invalidDomainLinkageCredentialIssuerInWellKnownDocument)
        try validate(input.credential.content.subject,
                     equals: input.credential.content.verifiableCredential.credentialSubject.did,
                     throws: DomainLinkageCredentialValidatorError.invalidDomainLinkageCredentialSubjectInWellKnownDocument)
        try validate(input.document.id,
                     equals: input.credential.content.verifiableCredential.credentialSubject.did,
                     throws: DomainLinkageCredentialValidatorError.invalidCredentialSubjectIdentifierInWellKnownDocument)
        try validate(input.domainUrl,
                     equals: input.credential.content.verifiableCredential.credentialSubject.domainUrl,
                     throws: DomainLinkageCredentialValidatorError.credentialSubjectOriginInvalid)
        
    }
    
    private func validate(token: DomainLinkageCredential, using keys: [IdentifierDocumentPublicKey]) throws {
        
        for key in keys {
            do {
                if try token.verify(using: verifier, withPublicKey: key.publicKeyJwk) {
                    return
                }
            } catch {
                // TODO: log error
            }
        }
        
        throw DomainLinkageCredentialValidatorError.invalidSignature
    }
    
    private func validate(_ value: String?, equals correctValue: String, throws error: Error) throws {
        guard value == correctValue else { throw error }
    }
}
