/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VcNetworking
import VcJwt

enum IssuanceUseCaseError: Error {
    case test
}

class IssuanceUseCase {
    typealias TokenFormatter = IssuanceResponseFormatter
    
    let masterIdentifier: MockIdentifier = MockIdentifier()
    let formatter: IssuanceResponseFormatter
    let repo: IssuanceRepository
    
    init(formatter: TokenFormatter = IssuanceResponseFormatter(),
         repo: IssuanceRepository = IssuanceRepository()) {
        self.formatter = formatter
        self.repo = repo
    }

    func getRequest(usingUrl url: String) -> Promise<Contract> {
        return self.repo.getRequest(withUrl: url)
    }

    func send(token: JwsToken<IssuanceResponseClaims>) -> Promise<VerifiableCredential> {
        
        // let signedToken = self.formatter.format(response: response, usingIdentifier: self.masterIdentifier)
        
        return self.repo.sendResponse(usingUrl:  "https://test3523.com", withBody: token)
    }
}
