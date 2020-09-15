/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VcNetworking
import VcJwt

class IssuanceUseCase {
    
    let masterIdentifier: MockIdentifier = MockIdentifier()
    let formatter: IssuanceResponseFormatter
    let repo: IssuanceRepository
    
    init(formatter: IssuanceResponseFormatter = IssuanceResponseFormatter(),
         repo: IssuanceRepository = IssuanceRepository()) {
        self.formatter = formatter
        self.repo = repo
    }

    func getRequest(usingUrl url: String) -> Promise<Contract> {
        return self.repo.getRequest(withUrl: url)
    }

    func send(response: MockIssuanceResponse, usingUrl url: String) throws -> Promise<VerifiableCredential> {
        let signedToken = try self.formatter.format(response: response, usingIdentifier: self.masterIdentifier)
        return self.repo.sendResponse(usingUrl: url, withBody: signedToken)
    }
}
