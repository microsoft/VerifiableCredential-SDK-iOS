/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VCEntities

enum PresentationUseCaseError: Error {
    case notImplemented
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
        let url = URL(string: urlStr)!
        print(url)
        let urlComponents = URLComponents(string: urlStr)!
        if let queryItems = urlComponents.percentEncodedQueryItems {
            for queryItem in queryItems {
                if queryItem.name == "request_uri" {
                    return self.repo.getRequest(withUrl: queryItem.value!)
                }
            }
        }
        return Promise { seal in
            seal.reject(PresentationUseCaseError.notImplemented)
        }
    }
    
    public func send(response: PresentationResponseContainer, identifier: MockIdentifier) -> Promise<String?> {
        return firstly {
            self.formatPresentationResponse(response: response, identifier: identifier)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  response.audience!, withBody: signedToken)
        }
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
