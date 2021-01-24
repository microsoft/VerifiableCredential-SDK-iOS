/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCEntities

public protocol PresentationNetworking {
    func getRequest(withUrl url: String) -> Promise<PresentationRequest>
    func sendResponse(usingUrl url: String, withBody body: PresentationResponse) -> Promise<String?>
}

public class PresentationNetworkCalls: PresentationNetworking {

    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func getRequest(withUrl url: String) -> Promise<PresentationRequest> {
        do {
            let operation = try FetchPresentationRequestOperation(withUrl: url, session: self.urlSession)
            return operation.fire()
        } catch {
            return Promise { seal in
                seal.reject(error)
            }
        }
    }
    
    public func sendResponse(usingUrl url: String, withBody body: PresentationResponse) -> Promise<String?> {
        do {
            let operation = try PostPresentationResponseOperation(usingUrl: url, withBody: body, urlSession: self.urlSession)
            return operation.fire()
        } catch {
            return Promise { seal in
                seal.reject(error)
            }
        }
    }
}

