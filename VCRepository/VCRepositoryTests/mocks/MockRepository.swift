/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

@testable import VCRepository

class MockRepository: Fetching, Posting {
    typealias FetchOperation = MockNetworkOperation
    typealias PostOperation = MockPostNetworkOperation
    
    let networkOperationFactory: NetworkOperationCreating
    
    init(networkOperationFactory: NetworkOperationCreating) {
        self.networkOperationFactory = networkOperationFactory
    }
    
    func getRequest(withUrl url: String) -> Promise<String> {
        return get(MockNetworkOperation.self, usingUrl: url)
    }
    
    func sendResponse(withUrl url: String, withBody body: String) -> Promise<String> {
        return post(MockPostNetworkOperation.self, usingUrl: url, withBody: body)
    }
}
