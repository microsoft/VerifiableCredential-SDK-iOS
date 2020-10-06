/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCNetworking
import PromiseKit
import VCEntities

public class PresentationRepository {
    
    private let apiCalls: ApiCalling
    
    public init(apiCalls: ApiCalling = ApiCalls()) {
        self.apiCalls = apiCalls
    }
    
    public func getRequest(withUrl url: String) -> Promise<PresentationRequest> {
        return self.apiCalls.get(FetchPresentationRequestOperation.self, usingUrl: url)
    }
    
    public func sendResponse(usingUrl url: String, withBody body: PresentationResponse) -> Promise<String?> {
        return self.apiCalls.post(PostPresentationResponseOperation.self, usingUrl: url, withBody: body)
    }
}
