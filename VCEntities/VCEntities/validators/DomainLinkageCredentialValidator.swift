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
    func validate(credential: DomainLinkageCredential,
                         usingDocument document: IdentifierDocument,
                         andSourceDomainUrl url: String) throws
}

public struct DomainLinkageCredentialValidator: DomainLinkageCredentialValidating {
    
    private let verifier: TokenVerifying
    
    public init(verifier: TokenVerifying = Secp256k1Verifier()) {
        self.verifier = verifier
    }
    
    public func validate(credential: DomainLinkageCredential,
                         usingDocument document: IdentifierDocument,
                         andSourceDomainUrl url: String) throws {
        
        let credentialSubjectDid = credential.content.verifiableCredential.credentialSubject.did
        let wellknownDocumentDomainUrl = credential.content.verifiableCredential.credentialSubject.domainUrl
        
        // try validate(token: credential, using: document.verificationMethod)
        
        try validate(credential.content.issuer,
                     equals: credentialSubjectDid,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(credentialSubject: credentialSubjectDid,
                                                                              tokenIssuer: credential.content.issuer))
        try validate(credential.content.subject,
                     equals: credentialSubjectDid,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(credentialSubject: credentialSubjectDid,
                                                                              tokenSubject: credential.content.subject))
        try validate(document.id,
                     equals: credentialSubjectDid,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(credentialSubject: credentialSubjectDid,
                                                                              identifierDocumentDid: document.id))
        try validate(url,
                     equals: wellknownDocumentDomainUrl,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(sourceDomainUrl: url,
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
