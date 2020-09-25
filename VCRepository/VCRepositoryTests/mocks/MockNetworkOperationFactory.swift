/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCNetworking
import PromiseKit

@testable import VCRepository

class MockNetworkOperationFactory: NetworkOperationCreating {
    let result: String
    
    init(result: String) {
        self.result = result
    }
    
    func createFetchOperation<T: NetworkOperation>(_ type: T.Type, withUrl url: String) -> Promise<T> {
        return Promise { seal in
            seal.fulfill(MockNetworkOperation(url: url, result: result) as! T)
        }
    }
    
    func createPostOperation<T: PostNetworkOperation>(_ type: T.Type, withUrl url: String, withRequestBody body: T.RequestBody) -> Promise<T> {
        return Promise { seal in
            seal.fulfill(MockPostNetworkOperation(result: result) as! T)
        }
    }
}
