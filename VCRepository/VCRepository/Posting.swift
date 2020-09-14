/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

public protocol Posting {
    var networkOperationFactory: NetworkOperationCreating { get }
    
    func post<PostOp: PostNetworkOperation>(_ type: PostOp.Type, usingUrl url: String, withBody body: PostOp.RequestBody) -> Promise<PostOp.ResponseBody>
}

public extension Posting {
    
    func post<PostOp: PostNetworkOperation>(_ type: PostOp.Type, usingUrl url: String, withBody body: PostOp.RequestBody) -> Promise<PostOp.ResponseBody> {
        return networkOperationFactory.createPostOperation(PostOp.self, withUrl: url, withRequestBody: body).then { operation in
            operation.fire()
        }
    }
}


