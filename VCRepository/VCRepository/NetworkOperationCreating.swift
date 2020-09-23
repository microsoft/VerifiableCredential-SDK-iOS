/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCNetworking
import PromiseKit

public protocol NetworkOperationCreating {
    func createFetchOperation<T: NetworkOperation>(_ type: T.Type, withUrl url: String) -> Promise<T>
    
    func createPostOperation<T: PostNetworkOperation>(_ type: T.Type, withUrl url: String, withRequestBody body: T.RequestBody) -> Promise<T>
}
