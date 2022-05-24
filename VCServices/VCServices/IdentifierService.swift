/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCEntities
import VCCrypto

public enum IdentifierServiceError: Error {
    case keyNotFoundInKeyStore(innerError: Error)
    case keyStoreError(message: String)
}

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
    
    public func doesMasterIdentifierExist() -> Bool {
        do
        {
            _ = try fetchMasterIdentifier()
            return true
        }
        catch
        {
            sdkLog.logError(message: "Master identifier does not exist with error: \(String(describing: error))")
            return false
        }
    }
    
    func refreshIdentifiers() throws {
        try identifierDB.removeAllIdentifiers()
        _ = try createAndSaveIdentifier(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: VCEntitiesConstants.MASTER_ID)
    }
    
    public func fetchIdentifiersForExport() throws -> [Identifier] {
        return try identifierDB.fetchAllIdentifiers()
    }
    
    public func replaceIdentifiers(with identifiers:[Identifier]) throws {
        
        try identifierDB.removeAllIdentifiers()
        try identifiers.forEach { identifier in
            try identifierDB.importIdentifier(identifier: identifier)
            
            // Ensure the keys are migrated into the correct access group
            let alias = identifier.alias
            do {
                let fetched = try identifierDB.fetchIdentifier(withAlias: alias)
                try migrateKeys(in: fetched, fromAccessGroup: nil)
            }
            catch {
                sdkLog.logWarning(message: "Failed to migrate keys in imported identifier w/alias: \(alias)")
            }
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
    
    func migrateKeys(in identifier:Identifier, fromAccessGroup currentAccessGroup: String?) throws {
        try identifier.recoveryKey.migrateKey(fromAccessGroup: currentAccessGroup)
        try identifier.updateKey.migrateKey(fromAccessGroup: currentAccessGroup)
        try identifier.didDocumentKeys.forEach { keyContainer in
            try keyContainer.migrateKey(fromAccessGroup: currentAccessGroup)
        }
    }
    
    /// updates access group for keys if it needs to be updated.
    func migrateKeys(fromAccessGroup currentAccessGroup: String?) throws {
        let identifier = try fetchMasterIdentifier()
        try migrateKeys(in: identifier, fromAccessGroup: currentAccessGroup)
    }
    
    func areKeysValid(for identifier: Identifier) throws {
        do {
            try identifier.recoveryKey.isValidKey()
            try identifier.updateKey.isValidKey()
            
            for key in identifier.didDocumentKeys {
                try key.isValidKey()
            }
        }
        catch {
            
            if case SecretStoringError.itemNotFound = error {
                throw IdentifierServiceError.keyNotFoundInKeyStore(innerError: error)
            }
            
            if case SecretStoringError.readFromStoreError(status: _, message: let message) = error {
                throw IdentifierServiceError.keyStoreError(message: message ?? "Unable to retrieve keys")
            }
            
            /// rethrow error if not key not found error.
            throw error
        }
    }
}
