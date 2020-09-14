/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

public protocol Fetching {
    var networkOperationFactory: NetworkOperationCreating { get }
    
    func get<FetchOp: NetworkOperation>(_ type: FetchOp.Type, usingUrl url: String) -> Promise<FetchOp.ResponseBody>
}

public extension Fetching {
    
    func get<FetchOp: NetworkOperation>(_ type: FetchOp.Type, usingUrl url: String) -> Promise<FetchOp.ResponseBody> {
        return networkOperationFactory.createFetchOperation(FetchOp.self, withUrl: url).then { operation in
            operation.fire()
        }
    }
}
