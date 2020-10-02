/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCEntities

@testable import VCUseCase

enum MockIssuanceResponseFormatterError: Error {
    case doNotWantToResolveRealObject
}

class MockIssuanceResponseFormatter: ResponseFormatting {
    
    static var wasFormatCalled = false
    let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func format(response: IssuanceResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponse {
        Self.wasFormatCalled = true
        if (shouldSucceed) {
            return IssuanceResponse(from: TestData.issuanceResponse.rawValue)!
        } else {
            throw MockIssuanceResponseFormatterError.doNotWantToResolveRealObject
        }
    }
}
