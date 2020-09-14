/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit

enum RepositoryError: Error {
    case unsupportedNetworkOperation
}

public protocol RepositoryProtocol {
    associatedtype FetchOperation: NetworkOperation
    associatedtype PostOperation: PostNetworkOperation
    
    var networkOperationFactory: NetworkOperationFactoryProtocol { get }
    
    init()
    
    func getRequest(withUrl url: String)-> Promise<FetchOperation.ResponseBody>
    
    func sendResponse(withUrl url: String, withBody body: PostOperation.RequestBody) -> Promise<PostOperation.ResponseBody>
}

public extension RepositoryProtocol {
    
    func getRequest(withUrl url: String) -> Promise<FetchOperation.ResponseBody> {
        return networkOperationFactory.createFetchOperation(FetchOperation.self, withUrl: url).then { operation in
            operation.fire()
        }
    }
    
    func sendResponse(withUrl url: String, withBody body: PostOperation.RequestBody) -> Promise<PostOperation.ResponseBody> {
        return networkOperationFactory.createPostOperation(PostOperation.self, withUrl: url, withRequestBody: body).then { operation in
            operation.fire()
        }
    }
}
