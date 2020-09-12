/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

@testable import VCRepository

class MockNetworkOperationFactory: NetworkOperationFactoryProtocol {
    
    let result: String
    
    init(result: String) {
        self.result = result
    }
    
    func create<T: NetworkOperation>(_ type: T.Type, withUrl url: String) throws -> T? {
        return MockNetworkOperation(url: url, result: result) as? T
    }
}
