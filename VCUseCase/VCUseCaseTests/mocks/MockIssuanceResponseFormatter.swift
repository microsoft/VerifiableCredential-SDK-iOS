/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt
import VCNetworking
import PromiseKit
import VCRepository

@testable import VCUseCase

class MockIssuanceResponseFormatter: IssuanceResponseFormatter {
    
    static var wasFormatCalled = false
    
    init() {
        print("hello")
    }
    
    override func format(response: IssuanceResponse, usingIdentifier identifier: MockIdentifier) -> Promise<JwsToken<IssuanceResponseClaims>> {
            Self.wasFormatCalled = true
        return Promise { seal in
            seal.fulfill(JwsToken<IssuanceResponseClaims>(headers: Header(), content: IssuanceResponseClaims(), signature: Data(count: 64)))
        }
    }
    
}
