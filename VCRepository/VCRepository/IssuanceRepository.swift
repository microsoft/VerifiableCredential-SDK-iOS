/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcNetworking
import VcJwt
import PromiseKit

enum IssuanceRepositoryError: Error {
    case unsupportedNetworkOperation
}

struct IssuanceRepository: RepositoryProtocol {
    public typealias FetchOperation = FetchContractOperation
    
    let networkOperationFactory: NetworkOperationFactoryProtocol = NetworkOperationFactory()
    
//    public func sendIssuanceResponse(withUrl url: String, withBody body: JwsToken<IssuanceResponseClaims>) throws -> Promise<JwsToken<VCClaims>> {
//        return try PostIssuanceResponseOperation(withUrl: url, withBody: body).fire()
//    }
}
