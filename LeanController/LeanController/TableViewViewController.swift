//
//  ViewController.swift
//  LeanController
//
//  Created by Luann Luna on 15/03/24.
//

import UIKit
import CoreData

class TableViewViewController: UITableViewController {

    private typealias Strings = LeanLocalizable

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.title.localized
        initializeCoreData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 44)
        ).with {
            $0.backgroundColor = .lightText
        }
        
        let textField = UITextField(frame: view.frame).with {
            $0.placeholder = Strings.placeholder.localized
            $0.leftView = UIView().with {
                $0.widthAnchor.constraint(equalToConstant: 10).isActive = true
            }
            $0.leftViewMode = .always
        }
        textField.delegate = self

        view.addSubview(textField)

        return view
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension TableViewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let managedObjectContext else { return false }
        if let shoppingList = NSEntityDescription.insertNewObject(forEntityName: TokenKeys.shoppingList.rawValue, into: managedObjectContext.self) as? ShoppingList {
            shoppingList.title = textField.text
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription); return false
            }

            return textField.resignFirstResponder()
        }
        return false
    }
}

private
extension TableViewViewController {
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

        let storeURL = documentsURL.appendingPathComponent("MyGrocery.sqlite")

        print(storeURL)

//        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//
//        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
//        self.managedObjectContext = NSManagedObjectContext(concurrencyType: type)
//        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
}
