//
//  ViewController.swift
//  LeanController
//
//  Created by Luann Luna on 15/03/24.
//

import UIKit
import CoreData

class TableViewViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCoreData()
    }


}

private
extension TableViewViewController {
    func initializeCoreData() {
        guard let modelURL = Bundle.main.url(forResource: "MyGroceryDataModel", withExtension: "momd") else {
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

        let storeURL = documentsURL.appendingPathComponent("MyGrocery.sqlite")

        print(storeURL)

//        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//
//        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
//        self.managedObjectContext = NSManagedObjectContext(concurrencyType: type)
//        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
}
