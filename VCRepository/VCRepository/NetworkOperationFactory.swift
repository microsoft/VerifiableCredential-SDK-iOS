/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import VcJwt
import PromiseKit

enum RepositoryError: Error {
    case unsupportedNetworkOperation
}

public class NetworkOperationFactory: NetworkOperationCreating {
    
    public init() {}
    
    public func createFetchOperation<T: NetworkOperation>(_ type: T.Type, withUrl url: String) -> Promise<T> {
        return Promise { seal in
            switch type {
            case is FetchContractOperation.Type:
                seal.fulfill(try FetchContractOperation(withUrl: url) as! T)
            default:
                seal.reject(RepositoryError.unsupportedNetworkOperation)
            }
        }
    }
    
    public func createPostOperation<T: PostNetworkOperation>(_ type: T.Type, withUrl url: String, withRequestBody body: T.RequestBody) -> Promise<T?> {
        return Promise { seal in
            switch type {
            case is PostIssuanceResponseOperation.Type:
                do {
                    let operation = try PostIssuanceResponseOperation(withUrl: url, withBody: body as! JwsToken<IssuanceResponseClaims>)
                    seal.fulfill(operation as? T)
                } catch {
                    seal.reject(error)
                }
            default:
                seal.reject(RepositoryError.unsupportedNetworkOperation)
            }
        }
    }
}
