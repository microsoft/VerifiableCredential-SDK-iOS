/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCRepository
import VCEntities

enum PresentationServiceError: Error {
    case inputStringNotUri
    case noQueryParametersOnUri
    case noValueForRequestUriQueryParameter
    case noRequestUriQueryParameter
}

public class PresentationService {
    
    let formatter: PresentationResponseFormatting
    let repo: PresentationRepository
    let identifierService: IdentifierService
    let exchangeService: ExchangeService
    
    public convenience init() {
        self.init(formatter: PresentationResponseFormatter(),
                  repo: PresentationRepository(),
                  identifierService: IdentifierService(),
                  exchangeService: ExchangeService())
    }
    
    init(formatter: PresentationResponseFormatting,
         repo: PresentationRepository,
         identifierService: IdentifierService,
         exchangeService: ExchangeService) {
        self.formatter = formatter
        self.repo = repo
        self.identifierService = identifierService
        self.exchangeService = exchangeService
    }
    
    public func getRequest(usingUrl urlStr: String) -> Promise<PresentationRequest> {
        return firstly {
            self.getRequestUriPromise(from: urlStr)
        }.then { requestUri in
            self.repo.getRequest(withUrl: requestUri)
        }
    }
    
    public func send(response: PresentationResponseContainer, withPairwiseDid: Bool = false) -> Promise<String?> {
        // TODO: create pairwise DID
        // TODO: exchange VCs
        // TODO: replace list of VCs
        return firstly {
            self.checkPairwiseBool(response: response)
        }.then { response in
            self.formatPresentationResponse(response: response)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  response.audience, withBody: signedToken)
        }
    }
    
    private func checkPairwiseBool(response: PresentationResponseContainer, withPairwiseDid isPairwise: Bool = false) -> Promise<PresentationResponseContainer> {
        if isPairwise {
            return self.pairwise(response: response)
        } else {
            return Promise { seal in
                seal.fulfill(response)
            }
        }
    }
    
    private func pairwise(response: PresentationResponseContainer) -> Promise<PresentationResponseContainer> {
        var res = response
        return firstly {
            self.createPairwiseIdentifier(forId: "master", andRelyingParty: response.audience)
        }.then { pairwiseIdentifier in
            self.exchangeRequestedVcs(vcs: response.requestVCMap, newOwnerDid: pairwiseIdentifier.longFormDid)
        }.then { vcMap in
            self.replaceResponseVcMap(response: &res, vcMap: vcMap)
        }
    }
    
    private func getRequestUriPromise(from urlStr: String) -> Promise<String> {
        return Promise { seal in
            do {
                seal.fulfill(try self.getRequestUri(from: urlStr))
            } catch {
                seal.reject(error)
            }
        }
    }
    
    private func getRequestUri(from urlStr: String) throws -> String {
        
        guard let urlStrWithoutPercentEncoding = urlStr.removingPercentEncoding,
            let urlComponents = URLComponents(string: urlStrWithoutPercentEncoding) else { throw PresentationServiceError.inputStringNotUri }
        guard let queryItems = urlComponents.percentEncodedQueryItems else { throw PresentationServiceError.noQueryParametersOnUri }
        
        for queryItem in queryItems {
            if queryItem.name == "request_uri" {
                guard let value = queryItem.value else { throw PresentationServiceError.noValueForRequestUriQueryParameter }
                return value
            }
        }
        
        throw PresentationServiceError.noRequestUriQueryParameter
    }
    
    private func formatPresentationResponse(response: PresentationResponseContainer) -> Promise<PresentationResponse> {
        return Promise { seal in
            do {
                
                guard let identifier = try identifierService.fetchMasterIdentifier() else {
                    throw IdentifierDatabaseError.noIdentifiersSaved
                }
                
                seal.fulfill(try self.formatter.format(response: response, usingIdentifier: identifier))
            } catch {
                seal.reject(error)
            }
        }
    }
    
    private func createPairwiseIdentifier(forId id: String, andRelyingParty rp: String) -> Promise<Identifier> {
        return Promise { seal in
            seal.fulfill(try identifierService.createAndSaveIdentifier(forId: id, andRelyingParty: rp))
        }
    }
    
    private func exchangeRequestedVcs(vcs: RequestedVerifiableCredentialMap, newOwnerDid: String) -> Promise<[TypeToVcTuple]> {
        var promises: [Promise<TypeToVcTuple>] = []
        for vc in vcs {
            promises.append(exchangeVerifiableCredential(type: vc.key, exchangeableVerifiableCredential: vc.value, newOwnerDid: newOwnerDid))
        }
        return when(fulfilled: promises)
    }
    
    private func exchangeVerifiableCredential(type: String, exchangeableVerifiableCredential vc: VerifiableCredential, newOwnerDid: String) -> Promise<TypeToVcTuple> {
        
        do {
            let ownerIdentifier = try getOwnerIdentifier(fromVc: vc)
            let exchangeRequest = try ExchangeRequestContainer(
                exchangeableVerifiableCredential: vc,
                newOwnerDid: newOwnerDid,
                currentOwnerIdentifier: ownerIdentifier)
            
            return firstly {
                self.exchangeService.send(request: exchangeRequest)
            }.then { vc in
                self.combineVCAndType(type: type, vc: vc)
            }
        } catch {
            return Promise { seal in
                seal.reject(error)
            }
        }
    }
    
    private func combineVCAndType(type: String, vc: VerifiableCredential) -> Promise<TypeToVcTuple> {
        return Promise { seal in
            seal.fulfill(TypeToVcTuple(type, vc))
        }
    }
    
    private func replaceResponseVcMap(response: inout PresentationResponseContainer, vcMap: [TypeToVcTuple]) -> Promise<PresentationResponseContainer> {
        let dict = Dictionary(uniqueKeysWithValues: vcMap)
        response.requestVCMap = dict
        return Promise { seal in
            seal.fulfill(response)
        }
    }
    
    private func getOwnerIdentifier(fromVc vc: VerifiableCredential) throws -> Identifier {
        let ownerLongformDid = vc.token.content.sub
        let nullableOwnerIdentifier = try identifierService.fetchIdentifer(withLongformDid: ownerLongformDid)
        
        guard let ownerIdentifier = nullableOwnerIdentifier else {
            throw PresentationServiceError.inputStringNotUri
        }
        
        return ownerIdentifier
    }
}

public typealias TypeToVcTuple = (String, VerifiableCredential)
