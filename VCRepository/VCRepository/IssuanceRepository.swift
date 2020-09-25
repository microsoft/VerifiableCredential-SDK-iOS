/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCNetworking
import PromiseKit
import VCEntities

public class IssuanceRepository {
    
    private let apiCalls: ApiCalling
    
    public init(apiCalls: ApiCalling = ApiCalls()) {
        self.apiCalls = apiCalls
    }
    
    public func getRequest(withUrl url: String) -> Promise<Contract> {
        return self.apiCalls.get(FetchContractOperation.self, usingUrl: url)
    }
    
    public func sendResponse(usingUrl url: String, withBody body: IssuanceResponse) -> Promise<VerifiableCredential> {
        return self.apiCalls.post(PostIssuanceResponseOperation.self, usingUrl: url, withBody: body)
    }
}
