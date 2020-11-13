/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VCEntities

class ExchangeService {
    
    let formatter: ExchangeRequestFormatting
    let repo: ExchangeRepository
    
    convenience init() {
        self.init(formatter: ExchangeRequestFormatter(), repo: ExchangeRepository())
    }
    
    init(formatter: ExchangeRequestFormatting, repo: ExchangeRepository) {
        self.formatter = formatter
        self.repo = repo
    }
    
    func send(request: ExchangeRequestContainer) -> Promise<VerifiableCredential> {
        return firstly {
            self.formatExchangeResponse(request: request)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  request.audience, withBody: signedToken)
        }
    }
    
    private func formatExchangeResponse(request: ExchangeRequestContainer) -> Promise<ExchangeRequest> {
        return Promise { seal in
            seal.fulfill(try self.formatter.format(request: request))
        }
    }
}
