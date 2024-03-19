//
//  CoreDataManager.swift
//  LeanController
//
//  Created by Luann Luna on 18/03/24.
//

import CoreData

class CoreDataManager {

    var managedObjectContext: NSManagedObjectContext

    init() {
        guard let modelURL = Bundle.main.url(forResource: TokenKeys.dataModel.rawValue, withExtension: TokenKeys.momd.rawValue) else {
            fatalError("GrocryDataModel not found")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to initialize ManagedObjectModel")
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let fileManager = FileManager()

        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to get documents URL")
        }

        let storeURL = documentsURL.appendingPathComponent(TokenKeys.sqlite.rawValue)

        print(storeURL)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }

        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
        managedObjectContext = NSManagedObjectContext(concurrencyType: type).with {
            $0.persistentStoreCoordinator = persistentStoreCoordinator
        }
    }
}
