/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCEntities

@testable import VCUseCase

class MockIssuanceResponseFormatter: IssuanceResponseFormatting {
    
    static var wasFormatCalled = false
    
    func format(response: IssuanceResponseContainer, usingIdentifier identifier: MockIdentifier) throws -> IssuanceResponse {
        Self.wasFormatCalled = true
        return IssuanceResponse(from: TestData.issuanceResponse.rawValue)!
    }
}
