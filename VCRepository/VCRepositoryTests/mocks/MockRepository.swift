/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

@testable import VCRepository

class MockRepository: RepositoryProtocol {
    typealias FetchOperation = MockNetworkOperation
    
    let networkOperationFactory: NetworkOperationFactoryProtocol
    
    init(result: String) {
        self.networkOperationFactory = MockNetworkOperationFactory(result: result)
    }
}
