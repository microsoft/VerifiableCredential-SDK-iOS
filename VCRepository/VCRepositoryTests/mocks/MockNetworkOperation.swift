/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

class MockNetworkOperation: NetworkOperation {
    typealias Decoder = MockDecoder
    
    var decoder: MockDecoder = MockDecoder()
    var urlSession: URLSession = URLSession.shared
    var urlRequest: URLRequest
    static var wasFireCalled: Bool = false
    let result: String
    
    init(url: String, result: String) {
        self.urlRequest = URLRequest(url: URL(string: url)!)
        self.result = result
    }
    
    func fire() -> Promise<String> {
        return Promise { seal in
            MockNetworkOperation.wasFireCalled = true
            seal.fulfill(self.result)
        }
    }
}
