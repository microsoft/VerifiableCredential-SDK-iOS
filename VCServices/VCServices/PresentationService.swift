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
    let identifierDatabase: IdentifierDatabase
    
    public convenience init() {
        self.init(formatter: PresentationResponseFormatter(),
                  repo: PresentationRepository())
    }
    
    init(formatter: PresentationResponseFormatting,
         repo: PresentationRepository) {
        self.formatter = formatter
        self.repo = repo
        self.identifierDatabase = IdentifierDatabase()
    }
    
    public func getRequest(usingUrl urlStr: String) -> Promise<PresentationRequest> {
        return firstly {
            self.getRequestUriPromise(from: urlStr)
        }.then { requestUri in
            self.repo.getRequest(withUrl: requestUri)
        }
    }
    
    public func send(response: PresentationResponseContainer) -> Promise<String?> {
        return firstly {
            self.formatPresentationResponse(response: response)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  response.audience, withBody: signedToken)
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
                
                guard let identifier = try identifierDatabase.fetchMasterIdentifier() else {
                    throw IdentifierDatabaseError.noIdentifiersSaved
                }
                
                seal.fulfill(try self.formatter.format(response: response, usingIdentifier: identifier))
            } catch {
                seal.reject(error)
            }
        }
    }
}
