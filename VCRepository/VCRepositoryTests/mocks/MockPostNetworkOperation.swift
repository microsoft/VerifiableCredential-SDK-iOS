/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

class MockPostNetworkOperation: PostNetworkOperation {
    typealias RequestBody = String
    
    static var wasFireCalled: Bool = false
    let result: String
    
    init(result: String) {
        self.result = result
    }
    
    func fire() -> Promise<String> {
        return Promise { seal in
            MockPostNetworkOperation.wasFireCalled = true
            seal.fulfill(self.result)
        }
    }
}
