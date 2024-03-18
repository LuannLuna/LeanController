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
        populateShoppingList()
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
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        let textField = UITextField(frame: view.frame).with {
            $0.placeholder = Strings.placeholder.localized
            $0.leftView = UIView().with {
                $0.widthAnchor.constraint(equalToConstant: 10).isActive = true
            }
            $0.leftViewMode = .always
            $0.delegate = self
        }

        view.addSubview(textField)

        return view
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = .init(style: .default, reuseIdentifier: "Cell")
        let shoppingList = fetchResultController?.object(at: indexPath)
        cell.textLabel?.text = shoppingList?.title

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            if let shoppingList = fetchResultController?.object(at: indexPath) {
                managedObjectContext?.delete(shoppingList)
                do {
                    try managedObjectContext?.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        tableView.isEditing = false
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
            textField.text = nil
            return textField.resignFirstResponder()
        }
        return false
    }
}

private
extension TableViewViewController {
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
        fetchResultController?.delegate = self
        do {
            try fetchResultController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension TableViewViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let newIndexPath else {
            if let indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            return
        }
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
