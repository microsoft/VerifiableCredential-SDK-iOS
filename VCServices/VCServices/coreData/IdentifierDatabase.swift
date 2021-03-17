/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCEntities
import VCCrypto

enum IdentifierDatabaseError: Error {
    case noIdentifiersSaved
    case unableToFetchMasterIdentifier
    case unableToSaveIdentifier
    case noAliasSavedInIdentifierModel
    case noIdentifierModelSaved
    case coreDataManagerNil
}

///Temporary until Deterministic Keys are implemented
struct IdentifierDatabase {
    
    private let coreDataManager = CoreDataManager.sharedInstance
    private let aliasComputer = AliasComputer()
    private let cryptoOperations: CryptoOperating
    
    init() {
        self.cryptoOperations = CryptoOperations()
    }
    
    init(cryptoOperations: CryptoOperating) {
        self.cryptoOperations = cryptoOperations
    }
    
    func saveIdentifier(identifier: Identifier) throws {

        
        /// signing key is always first key in DID document keys until we implement more complex registration scenario.
        guard let signingKey = identifier.didDocumentKeys.first else {
            throw IdentifierDatabaseError.unableToSaveIdentifier
        }
        
        try coreDataManager.saveIdentifier(longformDid: identifier.longFormDid,
                                           signingKeyId: signingKey.getId(),
                                           recoveryKeyId: identifier.recoveryKey.getId(),
                                           updateKeyId: identifier.updateKey.getId(),
                                           alias: identifier.alias)
    }
    
    func fetchMasterIdentifier() throws -> Identifier {
        let alias = aliasComputer.compute(forId: VCEntitiesConstants.MASTER_ID, andRelyingParty: VCEntitiesConstants.MASTER_ID)
        return try fetchIdentifier(withAlias: alias)
    }
    
    func fetchIdentifier(withAlias alias: String) throws -> Identifier {
        
        let identifierModels = try coreDataManager.fetchIdentifiers()
        
        var identifierModel: IdentifierModel? = nil
        
        for identifier in identifierModels {
            if identifier.alias == alias {
                identifierModel = identifier
            }
        }
        
        guard let model = identifierModel else {
            throw IdentifierDatabaseError.noIdentifierModelSaved
        }
        
        return try createIdentifier(fromIdentifierModel: model)
    }
    
    func fetchIdentifier(withLongformDid did: String) throws -> Identifier {
        
        let identifierModels = try coreDataManager.fetchIdentifiers()
        
        var identifierModel: IdentifierModel? = nil
        
        for identifier in identifierModels {
            if identifier.did == did {
                identifierModel = identifier
            }
        }
        
        guard let model = identifierModel else {
            throw IdentifierDatabaseError.noIdentifierModelSaved
        }
        
        return try createIdentifier(fromIdentifierModel: model)
    }
    
    private func createIdentifier(fromIdentifierModel model: IdentifierModel) throws -> Identifier {
        
        guard let longFormDid = model.did,
            let alias = model.alias else {
                throw IdentifierDatabaseError.noAliasSavedInIdentifierModel
        }
        
        let signingKeyContainer = try createKeyContainer(keyRefId: model.signingKeyId, keyId: VCEntitiesConstants.SIGNING_KEYID_PREFIX + alias)
        let updateKeyContainer = try createKeyContainer(keyRefId: model.updateKeyId, keyId: VCEntitiesConstants.UPDATE_KEYID_PREFIX + alias)
        let recoveryKeyContainer = try createKeyContainer(keyRefId: model.recoveryKeyId, keyId: VCEntitiesConstants.RECOVER_KEYID_PREFIX + alias)
        
        return Identifier(longFormDid: longFormDid,
                          didDocumentKeys: [signingKeyContainer],
                          updateKey: updateKeyContainer,
                          recoveryKey: recoveryKeyContainer,
                          alias: alias)
    }
    
    private func createKeyContainer(keyRefId: UUID?, keyId: String) throws -> KeyContainer {
        
        guard let keyUUID = keyRefId else {
            throw IdentifierDatabaseError.unableToFetchMasterIdentifier
        }
        
        let keyRef = try cryptoOperations.retrieveKeyFromStorage(withId: keyUUID)
        return KeyContainer(keyReference: keyRef, keyId: keyId)
    }
}
