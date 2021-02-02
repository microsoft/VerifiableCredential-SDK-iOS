/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCNetworking
import VCEntities

enum LinkedDomainResult: Error, Equatable {
    case linkedDomainMissing
    case linkedDomainUnverified(domainUrl: String)
    case linkedDomainVerified(domainUrl: String)
}

class LinkedDomainService {
    
    private let didDocumentDiscoveryApiCalls: DiscoveryNetworking
    private let wellKnownDocumentApiCalls: WellKnownConfigDocumentNetworking
    private let validator: DomainLinkageCredentialValidating
    
    init(didDocumentDiscoveryApiCalls: DiscoveryNetworking,
         wellKnownDocumentApiCalls: WellKnownConfigDocumentNetworking,
         domainLinkageValidator: DomainLinkageCredentialValidating) {
        self.didDocumentDiscoveryApiCalls = didDocumentDiscoveryApiCalls
        self.wellKnownDocumentApiCalls = wellKnownDocumentApiCalls
        self.validator = domainLinkageValidator
    }
    
    func validateLinkedDomain(from relyingPartyDid: String) -> Promise<LinkedDomainResult> {
        return firstly {
            self.getDidDocument(from: relyingPartyDid)
        }.then { identifierDocument in
            self.validateDomain(from: identifierDocument)
        }
    }
    
    private func validateDomain(from identifierDocument: IdentifierDocument) -> Promise<LinkedDomainResult> {
        
        guard let domainUrl = self.getLinkedDomainUrl(from: identifierDocument.service) else {
            return wrapResultInPromise(.linkedDomainMissing)
        }
        
        return firstly {
            self.wellKnownDocumentApiCalls.getDocument(fromUrl: domainUrl)
        }.then { wellKnownConfigDocument in
            self.validateDomainLinkageCredentials(from: wellKnownConfigDocument,
                                             using: identifierDocument,
                                             andSourceUrl: domainUrl)
        }
    }
    
    private func getDidDocument(from relyingPartyDid: String) -> Promise<IdentifierDocument> {
        return self.didDocumentDiscoveryApiCalls.getDocument(from: relyingPartyDid)
    }
    
    // only looking for the well-known document in the first entry for now.
    private func getLinkedDomainUrl(from endpoints: [IdentifierDocumentServiceEndpoint]) -> String? {
        return endpoints.filter {
            $0.type == Constants.LINKED_DOMAINS_SERVICE_ENDPOINT_TYPE
        }.first?.endpoint
    }
    
    private func validateDomainLinkageCredentials(from wellKnownConfigDoc: WellKnownConfigDocument,
                                                  using identifierDocument: IdentifierDocument,
                                                  andSourceUrl url: String) -> Promise<LinkedDomainResult> {
        
        var result = LinkedDomainResult.linkedDomainUnverified(domainUrl: url)
        wellKnownConfigDoc.linkedDids.forEach { credential in
            do {
                try validator.validate(credential: credential,
                                       usingDocument: identifierDocument,
                                       andSourceDomainUrl: url)
                result = .linkedDomainVerified(domainUrl: url)
            } catch { }
        }
        
        return wrapResultInPromise(result)
    }
    
    private func wrapResultInPromise(_ result: LinkedDomainResult) -> Promise<LinkedDomainResult> {
        return Promise { seal in
            seal.fulfill(result)
        }
    }
}
