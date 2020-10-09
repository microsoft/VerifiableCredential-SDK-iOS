/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import CoreData
import VCEntities

public class CoreDataManager {
    
    static let bundleId = "com.microsoft.VCUseCase"
    static let model = "CoreDataModel"
    
    lazy var persistentContainer: NSPersistentContainer = {
        
            let messageKitBundle = Bundle(identifier: CoreDataManager.bundleId)
            let modelURL = messageKitBundle!.url(forResource: CoreDataManager.model, withExtension: "momd")!
            let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
            let container = NSPersistentContainer(name: CoreDataManager.model, managedObjectModel: managedObjectModel!)
            container.loadPersistentStores { (storeDescription, error) in
                
                if let err = error {
                    print(err)
                }
            }
            
            return container
        }()
    
    public func saveIdentifier(longformDid: String,
                                      signingKeyId: UUID,
                                      recoveryKeyId: UUID,
                                      updateKeyId: UUID) throws {
        let context = persistentContainer.viewContext
        let model = NSEntityDescription.insertNewObject(forEntityName: "IdentifierModel", into: context) as! IdentifierModel
        
        model.longFormDid = longformDid
        model.recoveryKeyId = recoveryKeyId
        model.signingKeyId = signingKeyId
        model.updateKeyId = updateKeyId
    
        try context.save()
    }
    
    public func fetchIdentifier() throws -> [IdentifierModel] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<IdentifierModel>(entityName: "IdentifierModel")
        return try context.fetch(fetchRequest)
    }
    
}
