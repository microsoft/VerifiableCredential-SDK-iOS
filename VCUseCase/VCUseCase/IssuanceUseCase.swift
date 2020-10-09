/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VCEntities

public class IssuanceUseCase {
    
    let formatter: IssuanceResponseFormatting
    let repo: IssuanceRepository
    
    public init() {
        self.formatter = IssuanceResponseFormatter()
        self.repo = IssuanceRepository()
    }
    
    init(formatter: IssuanceResponseFormatting,
         repo: IssuanceRepository) {
        self.formatter = formatter
        self.repo = repo
    }
    
    public func getRequest(usingUrl url: String) -> Promise<Contract> {
        return self.repo.getRequest(withUrl: url)
    }
    
    public func send(response: IssuanceResponseContainer, identifier: Identifier) -> Promise<VerifiableCredential> {
        return firstly {
            self.formatIssuanceResponse(response: response, identifier: identifier)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  response.audience, withBody: signedToken)
        }
    }
    
    private func formatIssuanceResponse(response: IssuanceResponseContainer, identifier: Identifier) -> Promise<IssuanceResponse> {
        return Promise { seal in
            do {
                seal.fulfill(try self.formatter.format(response: response, usingIdentifier: identifier))
            } catch {
                seal.reject(error)
            }
        }
    }
}
