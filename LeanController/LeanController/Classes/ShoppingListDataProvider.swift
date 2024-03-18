//
//  ShoppingListDataProvider.swift
//  LeanController
//
//  Created by Luann Luna on 18/03/24.
//

import CoreData

class ShoppingListDataProvider: NSObject {
    let fetchResultController: NSFetchedResultsController<ShoppingList>

    var sections: [NSFetchedResultsSectionInfo]? {
        fetchResultController.sections
    }

    init(managedObjectContext: NSManagedObjectContext) {
        let request = NSFetchRequest<ShoppingList>(entityName: TokenKeys.shoppingList.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: TokenKeys.title.rawValue, ascending: true)]

        fetchResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

    func object(at indexPath: IndexPath) -> ShoppingList {
        fetchResultController.object(at: indexPath)
    }
}

extension ShoppingListDataProvider: NSFetchedResultsControllerDelegate {

}
