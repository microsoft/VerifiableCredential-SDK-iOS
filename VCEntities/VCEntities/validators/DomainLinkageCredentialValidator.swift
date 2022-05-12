/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

enum DomainLinkageCredentialValidatorError: Error, Equatable {
    case invalidSignature
    case tokenExpired
    case noPublicKeysInIdentifierDocument
    case doNotMatch(credentialSubject: String, tokenIssuer: String)
    case doNotMatch(credentialSubject: String, tokenSubject: String)
    case doNotMatch(credentialSubject: String, identifierDocumentDid: String)
    case doNotMatch(sourceDomainUrl: String, wellknownDocumentDomainUrl: String)
    case doNotMatch(linkedDomainCredentialKeyId: String?, identifierDocumentDid: String)
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
        
        guard let publicKeys = document.verificationMethod else {
            throw DomainLinkageCredentialValidatorError.noPublicKeysInIdentifierDocument
        }
        
        try validate(token: credential, using: publicKeys)
        
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
        
        /// Get DID from Key ID in Domain Linkage Credential Token Header
        let domainLinkedCredentialTokenHeaderDid = credential.headers.keyId?.split(separator: "#")[0] ?? ""
        try validate(String(domainLinkedCredentialTokenHeaderDid),
                     equals: document.id,
                     throws: DomainLinkageCredentialValidatorError.doNotMatch(linkedDomainCredentialKeyId: credential.headers.keyId,
                                                                              identifierDocumentDid: document.id))
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
    
    private func validate(_ value: String?, equals correctValue: String?, throws error: Error) throws {
        guard value == correctValue else { throw error }
    }
}
