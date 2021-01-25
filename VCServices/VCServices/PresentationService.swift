/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCNetworking
import VCEntities

enum PresentationServiceError: Error {
    case inputStringNotUri
    case noQueryParametersOnUri
    case noValueForRequestUriQueryParameter
    case noRequestUriQueryParameter
    case unableToCastToPresentationResponseContainer
}

public class PresentationService {
    
    let formatter: PresentationResponseFormatting
    let apiCalls: PresentationNetworking
    let identifierService: IdentifierService
    let pairwiseService: PairwiseService
    let sdkLog: VCSDKLog
    
    public convenience init() {
        self.init(formatter: PresentationResponseFormatter(),
                  apiCalls: PresentationNetworkCalls(),
                  identifierService: IdentifierService(),
                  pairwiseService: PairwiseService(),
                  sdkLog: VCSDKLog.sharedInstance)
    }
    
    init(formatter: PresentationResponseFormatting,
         apiCalls: PresentationNetworking,
         identifierService: IdentifierService,
         pairwiseService: PairwiseService,
         sdkLog: VCSDKLog = VCSDKLog.sharedInstance) {
        self.formatter = formatter
        self.apiCalls = apiCalls
        self.identifierService = identifierService
        self.pairwiseService = pairwiseService
        self.sdkLog = sdkLog
    }
    
    public func getRequest(usingUrl urlStr: String) -> Promise<PresentationRequest> {
        return firstly {
            self.getRequestUriPromise(from: urlStr)
        }.then { requestUri in
            self.apiCalls.getRequest(withUrl: requestUri)
        }
    }
    
    public func send(response: PresentationResponseContainer, isPairwise: Bool = false) -> Promise<String?> {
        return firstly {
            self.exchangeVCsIfPairwise(response: response, isPairwise: isPairwise)
        }.then { response in
            self.formatPresentationResponse(response: response, isPairwise: isPairwise)
        }.then { signedToken in
            self.apiCalls.sendResponse(usingUrl:  response.audienceUrl, withBody: signedToken)
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
        
        guard let urlComponents = URLComponents(string: urlStr) else { throw PresentationServiceError.inputStringNotUri }
        guard let queryItems = urlComponents.percentEncodedQueryItems else { throw PresentationServiceError.noQueryParametersOnUri }
        
        for queryItem in queryItems {
            if queryItem.name == "request_uri" {
                guard let value = queryItem.value?.removingPercentEncoding
                else { throw PresentationServiceError.noValueForRequestUriQueryParameter }
                return value
            }
        }
        
        throw PresentationServiceError.noRequestUriQueryParameter
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
    
    private func formatPresentationResponse(response: PresentationResponseContainer, isPairwise: Bool) -> Promise<PresentationResponse> {
        return Promise { seal in
            do {
                
                var identifier: Identifier?
                
                if isPairwise {
                    // TODO: will change when deterministic key generation is implemented.
                    identifier = try identifierService.fetchIdentifier(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: response.audienceDid)
                } else {
                    identifier = try identifierService.fetchMasterIdentifier()
                }
                
                guard let id = identifier else {
                    throw PresentationServiceError.inputStringNotUri
                }
                
                sdkLog.logInfo(message: "Signing Presentation Response with Identifier")
                
                seal.fulfill(try self.formatter.format(response: response, usingIdentifier: id))
            } catch {
                seal.reject(error)
            }
        }
    }
    
    private func castToPresentationResponse(from response: ResponseContaining) -> Promise<PresentationResponseContainer> {
        return Promise<PresentationResponseContainer> { seal in
            
            guard let presentationResponse = response as? PresentationResponseContainer else {
                seal.reject(PresentationServiceError.unableToCastToPresentationResponseContainer)
                return
            }
            
            seal.fulfill(presentationResponse)
        }
    }
}
