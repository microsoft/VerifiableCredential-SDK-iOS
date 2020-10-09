/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VCUseCase

class CoreDataManagerTests: XCTestCase {
    
    let dataManager = CoreDataManager()
    
    override func tearDownWithError() throws {
        try dataManager.deleteAllIdentifiers()
    }
    
    func testSavingIdentifier() throws {
        try dataManager.saveIdentifier(longformDid: "test", signingKeyId: UUID(), recoveryKeyId: UUID(), updateKeyId: UUID())
        print(try dataManager.fetchIdentifiers())
    }
}
