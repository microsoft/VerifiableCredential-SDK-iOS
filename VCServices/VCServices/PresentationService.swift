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
    let pairwiseService: PairwiseService
    
    public convenience init() {
        self.init(formatter: PresentationResponseFormatter(),
                  repo: PresentationRepository(),
                  identifierService: IdentifierService(),
                  pairwiseService: PairwiseService())
    }
    
    init(formatter: PresentationResponseFormatting,
         repo: PresentationRepository,
         identifierService: IdentifierService,
         pairwiseService: PairwiseService) {
        self.formatter = formatter
        self.repo = repo
        self.identifierService = identifierService
        self.pairwiseService = pairwiseService
    }
    
    public func getRequest(usingUrl urlStr: String) -> Promise<PresentationRequest> {
        return firstly {
            self.getRequestUriPromise(from: urlStr)
        }.then { requestUri in
            self.repo.getRequest(withUrl: requestUri)
        }
    }
    
    public func send(response: PresentationResponseContainer, isPairwise: Bool = false) -> Promise<String?> {
        return firstly {
            self.exchangeVCsIfPairwise(response: response, isPairwise: isPairwise)
        }.then { response in
            self.formatPresentationResponse(response: response, isPairwise: isPairwise)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  response.audienceUrl, withBody: signedToken)
        }
    }
    
    private func exchangeVCsIfPairwise(response: PresentationResponseContainer, isPairwise: Bool) -> Promise<PresentationResponseContainer> {
        if isPairwise {
            return firstly {
                pairwiseService.createPairwiseResponse(response: response)
            }.then { response in
                self.castToPresentationResponse(from: response)
            }
        } else {
            return Promise { seal in
                seal.fulfill(response)
            }
        }
    }
    
    private func castToPresentationResponse(from response: ResponseContaining) -> Promise<PresentationResponseContainer> {
        return Promise<PresentationResponseContainer> { seal in
            
            guard let presentationResponse = response as? PresentationResponseContainer else {
                seal.reject(PresentationServiceError.inputStringNotUri)
                return
            }
            
            seal.fulfill(presentationResponse)
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
    
    private func formatPresentationResponse(response: PresentationResponseContainer, isPairwise: Bool) -> Promise<PresentationResponse> {
        return Promise { seal in
            do {
                
                var identifier: Identifier?
                
                if isPairwise {
                    identifier = try identifierService.fetchIdentifier(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: response.audienceDid)
                } else {
                    identifier = try identifierService.fetchMasterIdentifier()
                }
                
                guard let id = identifier else {
                    throw PresentationServiceError.inputStringNotUri
                }
                
                seal.fulfill(try self.formatter.format(response: response, usingIdentifier: id))
            } catch {
                seal.reject(error)
            }
        }
    }
}
