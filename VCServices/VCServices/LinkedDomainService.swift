/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCNetworking
import VCEntities

enum LinkedDomainServiceError: String, Error {
    case UndefinedResolver = "DID Verification Resolver is undefined."
}

class LinkedDomainService {
    
    private let didDocumentDiscoveryApiCalls: DiscoveryNetworking
    private let wellKnownDocumentApiCalls: WellKnownConfigDocumentNetworking
    private let validator: DomainLinkageCredentialValidating
    
    private let didVerificationResolver: RootOfTrustResolver?
    
    public convenience init(correlationVector: CorrelationHeader? = nil,
                            didVerificationResolver: RootOfTrustResolver? = nil,
                            urlSession: URLSession = URLSession.shared) {
        self.init(didDocumentDiscoveryApiCalls: DIDDocumentNetworkCalls(correlationVector: correlationVector,
                                                                        urlSession: urlSession),
                  wellKnownDocumentApiCalls: WellKnownConfigDocumentNetworkCalls(correlationVector: correlationVector,
                                                                                 urlSession: urlSession),
                  domainLinkageValidator: DomainLinkageCredentialValidator(),
                  didVerificationResolver: didVerificationResolver)
    }
    
    init(didDocumentDiscoveryApiCalls: DiscoveryNetworking,
         wellKnownDocumentApiCalls: WellKnownConfigDocumentNetworking,
         domainLinkageValidator: DomainLinkageCredentialValidating,
         didVerificationResolver: RootOfTrustResolver? = nil) {
        self.didDocumentDiscoveryApiCalls = didDocumentDiscoveryApiCalls
        self.wellKnownDocumentApiCalls = wellKnownDocumentApiCalls
        self.validator = domainLinkageValidator
        self.didVerificationResolver = didVerificationResolver
    }
    
    func validateLinkedDomain(from relyingPartyDid: String) -> Promise<LinkedDomainResult> {
        return firstly {
            validateLinkedDomainUsingResolver(did: relyingPartyDid)
        }.then { result in
            return Promise { seal in
                seal.fulfill(result)
            }
        }.recover { error in
            return self.validateLinkedDomainUsingWellknownDocument(did: relyingPartyDid)
        }
    }
    
    private func validateLinkedDomainUsingResolver(did: String) -> Promise<LinkedDomainResult> {
        
        guard let didVerificationResolver = didVerificationResolver else {
            return Promise<LinkedDomainResult>(error: LinkedDomainServiceError.UndefinedResolver)
        }
        
        return Promise { seal in
            Task {
                do {
                    let result = try await didVerificationResolver.resolve(did: did)
                    seal.fulfill(result)
                } catch {
                    VCSDKLog.sharedInstance.logInfo(message: "DID Verification Resolver Failed with error: \(error), manually get Linked Domain Status...")
                    seal.reject(error)
                }
            }
        }
    }
    
    private func validateLinkedDomainUsingWellknownDocument(did: String) -> Promise<LinkedDomainResult> {
        return firstly {
            getDidDocument(from: did)
        }.then { identifierDocument in
            self.validateDomain(from: identifierDocument)
        }
    }
    
    private func validateDomain(from identifierDocument: IdentifierDocument) -> Promise<LinkedDomainResult> {
        
        guard let service = identifierDocument.service,
              let domainUrl = self.getLinkedDomainUrl(from: service) else {
            return wrapResultInPromise(.linkedDomainMissing)
        }
        
        return firstly {
            wellKnownDocumentApiCalls.getDocument(fromUrl: domainUrl)
        }.then { wellKnownConfigDocument in
            self.validateDomainLinkageCredentials(from: wellKnownConfigDocument,
                                                  using: identifierDocument,
                                                  andSourceUrl: domainUrl)
        }.recover { error in
            self.wrapResultInPromise(.linkedDomainUnverified(domainUrl: domainUrl))
        }
    }
    
    private func getDidDocument(from relyingPartyDid: String) -> Promise<IdentifierDocument> {
        return didDocumentDiscoveryApiCalls.getDocument(from: relyingPartyDid)
    }
    
    // only looking for the well-known document in the first entry for now.
    private func getLinkedDomainUrl(from endpoints: [IdentifierDocumentServiceEndpointDescriptor]) -> String? {
        return endpoints.filter {
            $0.type == Constants.LINKED_DOMAINS_SERVICE_ENDPOINT_TYPE
        }.first?.serviceEndpoint.origins?.first
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
