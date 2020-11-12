/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCNetworking
import PromiseKit
import VCEntities

public class ExchangeRepository {
    
    private let apiCalls: ApiCalling
    
    public init(apiCalls: ApiCalling = ApiCalls()) {
        self.apiCalls = apiCalls
    }
    
    public func sendResponse(usingUrl url: String, withBody body: ExchangeRequest) -> Promise<VerifiableCredential> {
        return self.apiCalls.post(PostExchangeRequestOperation.self, usingUrl: url, withBody: body)
    }
}
