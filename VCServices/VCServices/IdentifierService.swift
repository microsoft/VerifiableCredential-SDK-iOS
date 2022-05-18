/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCEntities
import VCCrypto

public class IdentifierService {
    
    private let identifierDB: IdentifierDatabase
    private let identifierCreator: IdentifierCreator
    private let sdkLog: VCSDKLog
    private let aliasComputer = AliasComputer()
    
    public convenience init() {
        let cryptoOperations = CryptoOperations(sdkConfiguration: VCSDKConfiguration.sharedInstance)
        self.init(database: IdentifierDatabase(cryptoOperations: cryptoOperations),
                  creator: IdentifierCreator(cryptoOperations: cryptoOperations),
                  sdkLog: VCSDKLog.sharedInstance)
    }
    
    init(database: IdentifierDatabase,
         creator: IdentifierCreator,
         sdkLog: VCSDKLog = VCSDKLog.sharedInstance) {
        self.identifierDB = database
        self.identifierCreator = creator
        self.sdkLog = sdkLog
    }
    
    public func fetchMasterIdentifier() throws -> Identifier {
        return try identifierDB.fetchMasterIdentifier()
    }
    
    public func fetchIdentifiersForExport() throws -> [Identifier] {
        return try identifierDB.fetchAllIdentifiers()
    }
    
    public func replaceIdentifiers(with identifiers:[Identifier]) throws {
        
        try identifierDB.removeAllIdentifiers()
        try identifiers.forEach { identifier in
            try identifierDB.importIdentifier(identifier: identifier)
        }
    }
    
    func fetchIdentifier(withAlias alias: String) throws -> Identifier {
        return try identifierDB.fetchIdentifier(withAlias: alias)
    }
    
    func fetchIdentifier(forId id: String, andRelyingParty rp: String) throws -> Identifier {
        let alias = aliasComputer.compute(forId: id, andRelyingParty: rp)
        let identifier = try identifierDB.fetchIdentifier(withAlias: alias)
        sdkLog.logInfo(message: "Fetched Identifier")
        return identifier
    }
    
    func fetchIdentifer(withLongformDid did: String) throws -> Identifier? {
        return try identifierDB.fetchIdentifier(withLongformDid: did)
    }
    
    func createAndSaveIdentifier(forId id: String, andRelyingParty rp: String) throws -> Identifier {
        let identifier = try identifierCreator.create(forId: id, andRelyingParty: rp)
        try identifierDB.saveIdentifier(identifier: identifier)
        sdkLog.logVerbose(message: "Created Identifier with alias:\(identifier.alias)")
        return identifier
    }
    
    /// updates access group for keys if it needs to be updated.
    public func migrateKeys(fromAccessGroup currentAccessGroup: String?) throws {
        try identifierDB.fetchAllIdentifiers().forEach { identifier in
            try identifier.recoveryKey.migrateKey(fromAccessGroup: currentAccessGroup)
            try identifier.updateKey.migrateKey(fromAccessGroup: currentAccessGroup)
            try identifier.didDocumentKeys.forEach { keyContainer in
                try keyContainer.migrateKey(fromAccessGroup: currentAccessGroup)
            }
        }
    }
    
    public func areKeysValid() throws -> Bool {
        let identifier = try fetchMasterIdentifier()
        return identifier.recoveryKey.isValidKey() &&
               identifier.updateKey.isValidKey() &&
               (identifier.didDocumentKeys.first?.isValidKey() ?? false)
    }
}
