//
//  CoreDataManager.swift
//  LeanController
//
//  Created by Luann Luna on 18/03/24.
//

import CoreData

class CoreDataManager {

    var managedObjectContext: NSManagedObjectContext?

    init() {
        initializeCoreData()
    }

    private
    func initializeCoreData() {
        guard let modelURL = Bundle.main.url(forResource: TokenKeys.dataModel.rawValue, withExtension: TokenKeys.momd.rawValue) else {
            print("GrocryDataModel not found"); return
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            print("Unable to initialize ManagedObjectModel"); return
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let fileManager = FileManager()

        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get documents URL"); return
        }

        let storeURL = documentsURL.appendingPathComponent(TokenKeys.sqlite.rawValue)

        print(storeURL)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            print(error.localizedDescription)
        }

        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
        managedObjectContext = NSManagedObjectContext(concurrencyType: type)
        managedObjectContext?.persistentStoreCoordinator = persistentStoreCoordinator
    }
}
