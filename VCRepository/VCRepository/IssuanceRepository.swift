/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit
import VcJwt

class IssuanceRepository {
    
    let apiCalls: ApiCalling
    
    init(apiCalls: ApiCalling = ApiCalls()) {
        self.apiCalls = apiCalls
    }
    
    func getRequest(withUrl url: String) -> Promise<Contract> {
        return self.apiCalls.get(FetchContractOperation.self, usingUrl: url)
    }
    
    func sendResponse(usingUrl url: String, withBody body: JwsToken<IssuanceResponseClaims>) -> Promise<VerifiableCredential> {
        return self.apiCalls.post(PostIssuanceResponseOperation.self, usingUrl: url, withBody: body)
    }
}
