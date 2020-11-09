/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import PromiseKit
import VCEntities

@testable import VCServices

enum MockPresentationResponseFormatterError: Error {
    case doNotWantToResolveRealObject
}

class MockPresentationResponseFormatter: PresentationResponseFormatting {
    
    static var wasFormatCalled = false
    let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func format(response: PresentationResponseContainer, usingIdentifier identifier: Identifier) throws -> PresentationResponse {
        Self.wasFormatCalled = true
        if (shouldSucceed) {
            return PresentationResponse(from: TestData.presentationResponse.rawValue)!
        } else {
            throw MockIssuanceResponseFormatterError.doNotWantToResolveRealObject
        }
    }
}
