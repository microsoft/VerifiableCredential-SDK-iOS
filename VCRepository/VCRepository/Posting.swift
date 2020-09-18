/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

protocol Posting {
    var networkOperationFactory: NetworkOperationCreating { get }
    
    func post<PostOp: PostNetworkOperation>(_ type: PostOp.Type, usingUrl url: String, withBody body: PostOp.RequestBody) -> Promise<PostOp.ResponseBody>
}

extension Posting {
    
    public func post<PostOp: PostNetworkOperation>(_ type: PostOp.Type, usingUrl url: String, withBody body: PostOp.RequestBody) -> Promise<PostOp.ResponseBody> {
        return firstly {
            networkOperationFactory.createPostOperation(PostOp.self, withUrl: url, withRequestBody: body)
        }.then { operation in
            operation.fire()
        }
    }
}


