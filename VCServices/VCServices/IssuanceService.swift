/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/


import PromiseKit
import VCRepository
import VCEntities

public class IssuanceService {
    
    let formatter: IssuanceResponseFormatting
    let repo: IssuanceRepository
    let identifierDatabase: IdentifierDatabase
    
    public convenience init() {
        self.init(formatter: IssuanceResponseFormatter(),
                  repo: IssuanceRepository())
    }
    
    init(formatter: IssuanceResponseFormatting, repo: IssuanceRepository) {
        self.formatter = formatter
        self.repo = repo
        self.identifierDatabase = IdentifierDatabase()
    }
    
    public func getRequest(usingUrl url: String) -> Promise<Contract> {
        return self.repo.getRequest(withUrl: url)
    }
    
    public func send(response: IssuanceResponseContainer) -> Promise<VerifiableCredential> {
        return firstly {
            self.formatIssuanceResponse(response: response)
        }.then { signedToken in
            self.repo.sendResponse(usingUrl:  response.audience, withBody: signedToken)
        }
    }
    
    private func formatIssuanceResponse(response: IssuanceResponseContainer) -> Promise<IssuanceResponse> {
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
