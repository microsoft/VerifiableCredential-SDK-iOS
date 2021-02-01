/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCEntities

public protocol IssuanceNetworking {
    func getRequest(withUrl url: String) -> Promise<SignedContract>
    func sendResponse(usingUrl url: String, withBody body: IssuanceResponse) -> Promise<VerifiableCredential>
}

public class IssuanceNetworkCalls: IssuanceNetworking {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func getRequest(withUrl url: String) -> Promise<SignedContract> {
        do {
            let operation = try FetchContractOperation(withUrl: url, session: self.urlSession)
            return operation.fire()
        } catch {
            return Promise { seal in
                seal.reject(error)
            }
        }
    }
    
    public func sendResponse(usingUrl url: String, withBody body: IssuanceResponse) -> Promise<VerifiableCredential> {
        do {
            let operation = try PostIssuanceResponseOperation(usingUrl: url, withBody: body, urlSession: self.urlSession)
            return operation.fire()
        } catch {
            return Promise { seal in
                seal.reject(error)
            }
        }
    }
}
