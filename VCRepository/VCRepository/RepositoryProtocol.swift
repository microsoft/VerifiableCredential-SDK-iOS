/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcNetworking
import VcJwt
import PromiseKit

enum RepositoryError: Error {
    case unsupportedNetworkOperation
}

protocol RepositoryProtocol {
    associatedtype FetchOperation: NetworkOperation
    
    var networkOperationFactory: NetworkOperationFactoryProtocol { get }
    
    func getRequest(withUrl url: String) throws -> Promise<FetchOperation.ResponseBody>
}

extension RepositoryProtocol {
    
    func getRequest(withUrl url: String) throws -> Promise<FetchOperation.ResponseBody> {
        let nullableOperation = try networkOperationFactory.create(FetchOperation.self, withUrl: url)
        
        guard let operation = nullableOperation else {
            throw RepositoryError.unsupportedNetworkOperation
        }
        
        return operation.fire()
    }
}
