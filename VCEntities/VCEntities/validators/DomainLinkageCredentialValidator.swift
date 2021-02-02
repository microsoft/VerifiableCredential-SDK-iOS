/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

enum DomainLinkageCredentialValidatorError: Error, Equatable {
    case invalidSignature
    case tokenExpired
    case doNotMatch(credentialSubject: String, tokenIssuer: String)
    case doNotMatch(credentialSubject: String, tokenSubject: String)
    case doNotMatch(credentialSubject: String, identifierDocumentDid: String)
    case doNotMatch(sourceDomainUrl: String, wellknownDocumentDomainUrl: String)
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
        
        let credentialSubjectDid = input.credential.content.verifiableCredential.credentialSubject.did
        let wellknownDocumentDomainUrl = input.credential.content.verifiableCredential.credentialSubject.domainUrl
        
        try validate(token: input.credential, using: input.document.verificationMethod)
        
        try validate(input.credential.content.issuer,
                     equals: credentialSubjectDid,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(credentialSubject: credentialSubjectDid,
                                                                              tokenIssuer: input.credential.content.issuer))
        try validate(input.credential.content.subject,
                     equals: credentialSubjectDid,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(credentialSubject: credentialSubjectDid,
                                                                              tokenSubject: input.credential.content.subject))
        try validate(input.document.id,
                     equals: input.credential.content.verifiableCredential.credentialSubject.did,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(credentialSubject: credentialSubjectDid,
                                                                              identifierDocumentDid: input.document.id))
        try validate(input.domainUrl,
                     equals: wellknownDocumentDomainUrl,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(sourceDomainUrl: input.domainUrl,
                                                                              wellknownDocumentDomainUrl: wellknownDocumentDomainUrl))
        
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
