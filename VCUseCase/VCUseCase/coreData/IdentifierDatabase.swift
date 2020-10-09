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
}

///Temporary until Deterministic Keys are implemented
struct IdentifierDatabase {
    
    let coreDataManager = CoreDataManager()
    let cryptoOperations: CryptoOperating
    
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
                                           updateKeyId: identifier.updateKey.getId())
    }
    
    func fetchMasterIdentifier() throws -> Identifier? {
        let identifierModels = try coreDataManager.fetchIdentifiers()
        
        guard let masterIdentifierModel = identifierModels.first else {
            return nil
        }
        
        guard let longFormDid = masterIdentifierModel.longFormDid else {
            throw IdentifierDatabaseError.unableToFetchMasterIdentifier
        }
        
        let signingKeyContainer = try createKeyContainer(keyRefId: masterIdentifierModel.signingKeyId, keyId: "sign")
        let updateKeyContainer = try createKeyContainer(keyRefId: masterIdentifierModel.updateKeyId, keyId: "update")
        let recoveryKeyContainer = try createKeyContainer(keyRefId: masterIdentifierModel.recoveryKeyId, keyId: "recover")
        
        return Identifier(longFormDid: longFormDid,
                          didDocumentKeys: [signingKeyContainer],
                          updateKey: updateKeyContainer,
                          recoveryKey: recoveryKeyContainer)
    }
    
    private func createKeyContainer(keyRefId: UUID?, keyId: String) throws -> KeyContainer {
        
        guard let keyUUID = keyRefId else {
            throw IdentifierDatabaseError.unableToFetchMasterIdentifier
        }
        
        let keyRef = try cryptoOperations.retrieveKeyFromStorage(withId: keyUUID)
        return KeyContainer(keyReference: keyRef, keyId: keyId)
    }
}
