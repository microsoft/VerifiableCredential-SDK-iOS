/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCEntities

class IdentifierService {
    
    private let identifierDB: IdentifierDatabase
    private let identifierCreator: IdentifierCreator
    private let aliasComputer = AliasComputer()
    
    convenience init() {
        self.init(database: IdentifierDatabase(), creator: IdentifierCreator())
    }
    
    init(database: IdentifierDatabase, creator: IdentifierCreator) {
        self.identifierDB = database
        self.identifierCreator = creator
    }
    
    func fetchMasterIdentifier() throws -> Identifier? {
        return try identifierDB.fetchMasterIdentifier()
    }
    
    func fetchIdentifier(withAlias alias: String) throws -> Identifier? {
        return try identifierDB.fetchIdentifier(withAlias: alias)
    }
    
    func fetchIdentifier(forId id: String, andRelyingParty rp: String) throws -> Identifier? {
        let alias = aliasComputer.compute(forId: id, andRelyingParty: rp)
        let identifier = try identifierDB.fetchIdentifier(withAlias: alias)
        VCSDKLog.i(message: "Created Identifier: \(String(describing: identifier?.longFormDid))")
        return identifier
    }
    
    func fetchIdentifer(withLongformDid did: String) throws -> Identifier? {
        return try identifierDB.fetchIdentifier(withLongformDid: did)
    }
    
    func createAndSaveIdentifier(forId id: String, andRelyingParty rp: String) throws -> Identifier {
        let identifier = try identifierCreator.create(forId: id, andRelyingParty: rp)
        try identifierDB.saveIdentifier(identifier: identifier)
        VCSDKLog.i(message: "Created Identifier with alias:\(identifier.alias)")
        return identifier
    }
}
