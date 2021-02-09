/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCEntities

public protocol WellKnownConfigDocumentNetworking {
    func getDocument(fromUrl domainUrl: String) -> Promise<WellKnownConfigDocument>
}

public class WellKnownConfigDocumentNetworkCalls: WellKnownConfigDocumentNetworking {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func getDocument(fromUrl domainUrl: String) -> Promise<WellKnownConfigDocument> {
        do {
            let operation = try FetchWellKnownConfigDocumentOperation(withUrl: domainUrl)
            return operation.fire()
        } catch {
            return Promise { seal in
                seal.reject(error)
            }
        }
    }
}

