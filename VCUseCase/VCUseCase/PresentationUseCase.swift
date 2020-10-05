/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCRepository
import VCEntities

enum PresentationUseCaseError: Error {
    case inputStringNotUri
    case noQueryParametersOnUri
    case noValueForRequestUriQueryParameter
    case noRequestUriQueryParameter
}

public class PresentationUseCase {
    
    let masterIdentifier: MockIdentifier = MockIdentifier()
    let formatter: PresentationResponseFormatting
    let repo: PresentationRepository
    
    public init() {
        self.formatter = PresentationResponseFormatter()
        self.repo = PresentationRepository()
    }
    
    init(formatter: PresentationResponseFormatting,
         repo: PresentationRepository) {
        self.formatter = formatter
        self.repo = repo
    }
    
    public func getRequest(usingUrl urlStr: String) -> Promise<PresentationRequest> {
        return firstly {
            self.getRequestUriPromise(from: urlStr)
        }.then { requestUri in
            self.repo.getRequest(withUrl: requestUri)
        }
    }
    
    public func send(response: PresentationResponseContainer, identifier: MockIdentifier) -> Promise<String?> {
        return firstly {
            self.formatPresentationResponse(response: response, identifier: identifier)
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
        
        guard let urlComponents = URLComponents(string: urlStr) else { throw PresentationUseCaseError.inputStringNotUri }
        guard let queryItems = urlComponents.percentEncodedQueryItems else { throw PresentationUseCaseError.noQueryParametersOnUri }
        
        for queryItem in queryItems {
            if queryItem.name == "request_uri" {
                guard let value = queryItem.value else { throw PresentationUseCaseError.noValueForRequestUriQueryParameter }
                return value
            }
        }
        
        throw PresentationUseCaseError.noRequestUriQueryParameter
    }
    
    private func formatPresentationResponse(response: PresentationResponseContainer, identifier: MockIdentifier) -> Promise<PresentationResponse> {
        return Promise { seal in
            do {
                seal.fulfill(try self.formatter.format(response: response, usingIdentifier: identifier))
            } catch {
                seal.reject(error)
            }
        }
    }
}
