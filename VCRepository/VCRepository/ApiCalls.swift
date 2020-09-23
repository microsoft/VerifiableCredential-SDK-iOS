/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCNetworking
import PromiseKit

internal protocol InternalApiCalling: InternalApi, ApiCalling { }

public protocol ApiCalling {
    func get<FetchOp: NetworkOperation>(_ type: FetchOp.Type, usingUrl url: String) -> Promise<FetchOp.ResponseBody>
    
    func post<PostOp: PostNetworkOperation>(_ type: PostOp.Type, usingUrl url: String, withBody body: PostOp.RequestBody) -> Promise<PostOp.ResponseBody>
}

protocol InternalApi: Fetching, Posting { }

public class ApiCalls: InternalApiCalling {
    
    let networkOperationFactory: NetworkOperationCreating
    
    public init(networkOperationFactory: NetworkOperationCreating = NetworkOperationFactory()) {
        self.networkOperationFactory = networkOperationFactory
    }
}
