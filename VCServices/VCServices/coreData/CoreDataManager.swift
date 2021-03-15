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
        static let model = "VerifiableCredentialDataModel"
        static let identifierModel = "IdentifierModel"
        static let extensionType = "momd"
        static let sqliteDescription = "sqlite"
    }
    
    public static let sharedInstance = CoreDataManager()
    
    private var persistentContainer: NSPersistentContainer
    
    let sdkLog: VCSDKLog
    
    private init?(sdkLog: VCSDKLog = VCSDKLog.sharedInstance) {
        
        self.sdkLog = sdkLog
        
        guard let container = CoreDataManager.createPersistentContainer(sdkLog: sdkLog) else {
            return nil
        }
        
       self.persistentContainer = container
    }
    
    public func saveIdentifier(longformDid: String,
                               signingKeyId: UUID,
                               recoveryKeyId: UUID,
                               updateKeyId: UUID,
                               alias: String) throws {
        
        let model = NSEntityDescription.insertNewObject(forEntityName: Constants.identifierModel,
                                                        into: persistentContainer.viewContext) as! IdentifierModel
        
        model.did = longformDid
        model.recoveryKeyId = recoveryKeyId
        model.signingKeyId = signingKeyId
        model.updateKeyId = updateKeyId
        model.alias = alias
        
        try persistentContainer.viewContext.save()
    }
    
    public func fetchIdentifiers() throws -> [IdentifierModel] {
        
        let fetchRequest: NSFetchRequest<IdentifierModel> = IdentifierModel.fetchRequest()
        return try persistentContainer.viewContext.fetch(fetchRequest)
    }
    
    public func deleteAllIdentifiers() throws {
        
        let fetchRequest: NSFetchRequest<IdentifierModel> = IdentifierModel.fetchRequest()
        let models = try persistentContainer.viewContext.fetch(fetchRequest)
        
        for model in models {
            persistentContainer.viewContext.delete(model)
        }
        
        try persistentContainer.viewContext.save()
    }
    
    private static func createPersistentContainer(sdkLog: VCSDKLog) -> NSPersistentContainer? {
        
        let messageKitBundle = Bundle(for: Self.self)
        
        guard let modelURL = messageKitBundle.url(forResource: Constants.model, withExtension: Constants.extensionType),
              let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }
        
        let container = NSPersistentContainer(name: Constants.model, managedObjectModel: managedObjectModel)
        
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error?.localizedDescription {
                sdkLog.logError(message: err)
            }
        }
        
        return container
    }
}
