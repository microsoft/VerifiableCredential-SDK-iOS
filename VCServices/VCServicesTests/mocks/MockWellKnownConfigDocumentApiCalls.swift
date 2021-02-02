/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCNetworking
import VCEntities
import PromiseKit

@testable import VCServices

enum MockWellKnownConfigDocumentNetworkingError: Error {
    case doNotWantToResolveRealObject
}

class MockWellKnownConfigDocumentApiCalls: WellKnownConfigDocumentNetworking {

    static var wasGetCalled = false
    let resolveSuccessfully: Bool
    
    init(resolveSuccessfully: Bool = true) {
        self.resolveSuccessfully = resolveSuccessfully
    }
    
    func getDocument(fromUrl domainUrl: String) -> Promise<WellKnownConfigDocument> {
        Self.wasGetCalled = true
        return Promise { seal in
            if self.resolveSuccessfully {
                seal.fulfill(IdentifierDocument(service: ["service"], verificationMethod: [], authentication: ["authentication"], id: "did:test:67453"))
            } else {
                seal.reject(MockDiscoveryNetworkingError.doNotWantToResolveRealObject)
            }
        }
    }
}

