//
//  ShoppingListDataSource.swift
//  LeanController
//
//  Created by Luann Luna on 18/03/24.
//

import UIKit
import CoreData

class ShoppingListDataSource: NSObject, UITableViewDataSource {

    let dataProvider: ShoppingListDataProvider
    var tableView: UITableView?

    init(dataProvider: ShoppingListDataProvider) {
        self.dataProvider = dataProvider
        super.init()
        dataProvider.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = dataProvider.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = .init(style: .default, reuseIdentifier: "Cell")
        let shoppingList = dataProvider.object(at: indexPath)
        cell.textLabel?.text = shoppingList.title

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            let shoppingList = dataProvider.object(at: indexPath)
            dataProvider.fetchResultController.managedObjectContext.delete(shoppingList)
            do {
                try dataProvider.fetchResultController.managedObjectContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        tableView.isEditing = false
    }
}

extension ShoppingListDataSource: ShoppingListDataProviderDelegate {
    func shoppingListDataProviderDidInsert(indexPath: IndexPath) {
        tableView?.insertRows(at: [indexPath], with: .automatic)
    }
    
    func shoppingListDataProviderDidDelete(indexPath: IndexPath) {
        tableView?.deleteRows(at: [indexPath], with: .automatic)
    }
}
