/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VCEntities

public class PresentationUseCase {
    
    let masterIdentifier: MockIdentifier = MockIdentifier()
    let formatter: PresentationResponseFormatter
    let repo: PresentationRepository
    
    public init() {
        self.formatter = PresentationResponseFormatter()
        self.repo = PresentationRepository()
    }
    
    init(formatter: PresentationResponseFormatter,
         repo: PresentationRepository) {
        self.formatter = formatter
        self.repo = repo
    }
    
    public func getRequest(usingUrl url: String) -> Promise<PresentationRequest> {
        return self.repo.getRequest(withUrl: url)
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
