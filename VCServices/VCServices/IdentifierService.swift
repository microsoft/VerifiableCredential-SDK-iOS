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
    private let cryptoOperations: CryptoOperations
    
    public convenience init() {
        let cryptoOperations = CryptoOperations(sdkConfiguration: VCSDKConfiguration.sharedInstance)
        self.init(cryptoOperations: cryptoOperations,
                  database: IdentifierDatabase(cryptoOperations: cryptoOperations),
                  creator: IdentifierCreator(cryptoOperations: cryptoOperations),
                  sdkLog: VCSDKLog.sharedInstance)
    }
    
    init(cryptoOperations: CryptoOperations,
         database: IdentifierDatabase,
         creator: IdentifierCreator,
         sdkLog: VCSDKLog = VCSDKLog.sharedInstance) {
        self.cryptoOperations = cryptoOperations
        self.identifierDB = database
        self.identifierCreator = creator
        self.sdkLog = sdkLog
    }
    
    public func fetchMasterIdentifier() throws -> Identifier {
        return try identifierDB.fetchMasterIdentifier()
    }
    
    public func fetchIdentifiersForExport() throws -> [Identifier] {
        return try identifierDB.fetchAllIdentifiers().map(self.prep)
    }
    
    private func rewrap(_ keyContainer: KeyContainer) throws -> KeyContainer {
        
        let secret = keyContainer.keyReference
        let keyReference = KeyReference(id: secret.id, ops:self.cryptoOperations)
        return KeyContainer(keyReference: keyReference,
                            keyId: keyContainer.keyId)
    }
    
    private func prep(_ identifier: Identifier) throws -> Identifier {
        
        let documentKeys = try identifier.didDocumentKeys.map(self.rewrap)
        return Identifier(longFormDid: identifier.longFormDid,
                          didDocumentKeys: documentKeys,
                          updateKey: try self.rewrap(identifier.updateKey),
                          recoveryKey: try self.rewrap(identifier.recoveryKey),
                          alias: identifier.alias)
    }
    
    public func replaceIdentifiers(with identifiers:[Identifier], keyMap keys: KeyMap) throws {
        
        try identifierDB.removeAllIdentifiers()
        try identifiers.forEach { identifier in
            try identifierDB.importIdentifier(identifier: identifier, keyMap: keys)
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
