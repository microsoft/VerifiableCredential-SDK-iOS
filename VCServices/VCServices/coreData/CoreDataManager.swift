/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import CoreData
import VCEntities

enum CoreDataManagerError: Error {
    case unableToCreatePersistentContainer
}

/// Temporary Until Deterministic Keys are implemented.
public class CoreDataManager {
    
    private struct Constants {
        static let bundleId = "com.microsoft.VCUseCase"
        static let model = "CoreDataModel"
        static let identifierModel = "IdentifierModel"
        static let extensionType = "momd"
        static let sqliteDescription = "sqlite"
    }
    
    public static let sharedInstance = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer? = {
        
        let messageKitBundle = Bundle(for: Self.self)
        
        guard let modelURL = messageKitBundle.url(forResource: Constants.model, withExtension: Constants.extensionType),
              let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }
        
        let container = NSPersistentContainer(name: Constants.model, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error?.localizedDescription {
                VCSDKLog.sharedInstance.logError(message: err)
            }
        }
        
        return container
    }()
    
    let sdkLog: VCSDKLog
    
    private init?(sdkLog: VCSDKLog = VCSDKLog.sharedInstance) {
        
        self.sdkLog = sdkLog
        
        do {
            try migrateStoreIfNeeded()
        } catch {
            return nil
        }
    }
    
    public func saveIdentifier(longformDid: String,
                                      signingKeyId: UUID,
                                      recoveryKeyId: UUID,
                                      updateKeyId: UUID,
                                      alias: String) throws {
        
        guard let context = persistentContainer?.viewContext else {
            throw CoreDataManagerError.unableToCreatePersistentContainer
        }
        
        let model = NSEntityDescription.insertNewObject(forEntityName: Constants.identifierModel, into: context) as! IdentifierModel
        
        model.longFormDid = longformDid
        model.recoveryKeyId = recoveryKeyId
        model.signingKeyId = signingKeyId
        model.updateKeyId = updateKeyId
        model.alias = alias
    
        try context.save()
    }
    
    public func fetchIdentifiers() throws -> [IdentifierModel] {
        
        guard let context = persistentContainer?.viewContext else {
            throw CoreDataManagerError.unableToCreatePersistentContainer
        }
        
        let fetchRequest: NSFetchRequest<IdentifierModel> = IdentifierModel.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    public func deleteAllIdentifiers() throws {
        
        guard let context = persistentContainer?.viewContext else {
            throw CoreDataManagerError.unableToCreatePersistentContainer
        }
        
        let fetchRequest: NSFetchRequest<IdentifierModel> = IdentifierModel.fetchRequest()
        let models = try context.fetch(fetchRequest)
        
        for model in models {
            context.delete(model)
        }
    
        try context.save()
    }
    
    /// Migrate the store if needed
    private func migrateStoreIfNeeded() throws {
        
        guard let container = persistentContainer else {
            throw CoreDataManagerError.unableToCreatePersistentContainer
        }
        
        let messageKitBundle = Bundle(for: Self.self)
        var url = messageKitBundle.url(forResource: Constants.model, withExtension: Constants.extensionType)!
        url = url.appendingPathComponent("\(Constants.identifierModel).\(Constants.sqliteDescription)")

        var isCompatible = true
        do {
            let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: Constants.sqliteDescription, at: url, options: nil)
            isCompatible = container.managedObjectModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
        } catch {
            // TODO log the error.
            // We mark the store as incompatible if we can't read its metadata
            isCompatible = false
        }

        if !isCompatible {
            // At this point, we destroy the store when it's incompatible. we will handle migration when we get closer to public preview.
            // Bug 1176814: Handle store migration
            do {
                try container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: Constants.sqliteDescription, options: nil)
            } catch {
                // TODO log the error.
            }
        }
    }
    
}
