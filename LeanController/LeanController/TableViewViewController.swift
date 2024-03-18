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

    var fetchResultController: NSFetchedResultsController<ShoppingList>?
    var managedObjectContext: NSManagedObjectContext?

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

    func populateShoppingList() {
        guard let managedObjectContext else { return }
        let request = NSFetchRequest<ShoppingList>(entityName: TokenKeys.shoppingList.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: TokenKeys.title.rawValue, ascending: true)]

        fetchResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            try fetchResultController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension TableViewViewController: NSFetchedResultsControllerDelegate {

}

private
extension TableViewViewController {
    enum TokenKeys: String {
        case shoppingList = "ShoppingList"
        case dataModel = "MyGroceryDataModel"
        case momd
        case sqlite = "MyGrocery.sqlite"
        case title
    }
}
