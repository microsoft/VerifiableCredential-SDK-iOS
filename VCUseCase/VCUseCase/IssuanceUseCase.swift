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

public class IssuanceUseCase {
    typealias TokenFormatter = IssuanceResponseFormatter
    
    let masterIdentifier: MockIdentifier = MockIdentifier()
    let formatter: IssuanceResponseFormatter
    let repo: IssuanceRepository
    
    public init() {
        self.formatter = IssuanceResponseFormatter()
        self.repo = IssuanceRepository()
    }
    
    init(formatter: TokenFormatter = IssuanceResponseFormatter(),
         repo: IssuanceRepository = IssuanceRepository()) {
        self.formatter = formatter
        self.repo = repo
    }

    public func getRequest(usingUrl url: String) -> Promise<Contract> {
        return self.repo.getRequest(withUrl: url)
    }

    public func send(response: MockIssuanceResponse) -> Promise<VerifiableCredential> {
        return firstly {
            self.formatter.format(response: response, usingIdentifier: self.masterIdentifier)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  response.audience, withBody: signedToken)
        }
    }
}