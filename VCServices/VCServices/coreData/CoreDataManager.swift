/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import CoreData
import VCEntities

/// Temporary Until Deterministic Keys are implemented.
public class CoreDataManager {
    
    public static let sharedInstance = CoreDataManager()
    
    static let bundleId = "com.microsoft.VCUseCase"
    static let model = "CoreDataModel"
    static let identifierModel = "IdentifierModel"
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(for: Self.self)
        let modelURL = messageKitBundle.url(forResource: CoreDataManager.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        let container = NSPersistentContainer(name: CoreDataManager.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error {
                print(err)
            }
        }
        
        return container
    }()
    
    private init() {
        migrateStoreIfNeeded()
    }
    
    public func saveIdentifier(longformDid: String,
                                      signingKeyId: UUID,
                                      recoveryKeyId: UUID,
                                      updateKeyId: UUID,
                                      alias: String) throws {
        let context = persistentContainer.viewContext
        let model = NSEntityDescription.insertNewObject(forEntityName: CoreDataManager.identifierModel, into: context) as! IdentifierModel
        
        model.longFormDid = longformDid
        model.recoveryKeyId = recoveryKeyId
        model.signingKeyId = signingKeyId
        model.updateKeyId = updateKeyId
        model.alias = alias
    
        try context.save()
    }
    
    public func fetchIdentifiers() throws -> [IdentifierModel] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<IdentifierModel> = IdentifierModel.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    public func deleteAllIdentifiers() throws {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<IdentifierModel> = IdentifierModel.fetchRequest()
        let models = try context.fetch(fetchRequest)
        
        for model in models {
            context.delete(model)
        }
    
        try context.save()
    }
    
    /// Migrate the store if needed
    private func migrateStoreIfNeeded() {
        
        let messageKitBundle = Bundle(for: Self.self)
        var url = messageKitBundle.url(forResource: CoreDataManager.model, withExtension: "momd")!
        url = url.appendingPathComponent("\(CoreDataManager.identifierModel).sqlite")

        var isCompatible = true
        do {
            let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: "sqlite", at: url, options: nil)
            isCompatible = persistentContainer.managedObjectModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
        } catch {
            // TODO log the error.
            // We mark the store as incompatible if we can't read its metadata
            isCompatible = false
        }

        if !isCompatible {
            // At this point, we destroy the store when it's incompatible. we will handle migration when we get closer to public preview.
            // Bug 1176814: Handle store migration
            do {
                try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: "sqlite", options: nil)
            } catch {
                // TODO log the error.
            }
        }
    }
    
}
