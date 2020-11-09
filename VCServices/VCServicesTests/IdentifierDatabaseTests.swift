/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest
import VCCrypto
import VCEntities

@testable import VCServices

class IdentifierDatabaseTests: XCTestCase {
    
    let dataManager = CoreDataManager()
    var identifierCreator: IdentifierCreator!
    var identifierDB: IdentifierDatabase!
    
    override func setUpWithError() throws {
        let cryptoOperations = CryptoOperations()
        identifierDB = IdentifierDatabase(cryptoOperations: cryptoOperations)
        identifierCreator = IdentifierCreator(cryptoOperations: cryptoOperations)
    }
    
    override func tearDownWithError() throws {
        try identifierDB.coreDataManager.deleteAllIdentifiers()
    }
    
    func testSavingIdentifier() throws {
        let testIdentifier = try identifierCreator.create()
        print(testIdentifier.longFormDid)
        try identifierDB.saveIdentifier(identifier: testIdentifier)
        let fetchedIdentifier = try identifierDB.fetchMasterIdentifier()!
        XCTAssertEqual(testIdentifier.longFormDid, fetchedIdentifier.longFormDid)
    }
}
