//
//  ShoppingListDataProvider.swift
//  LeanController
//
//  Created by Luann Luna on 18/03/24.
//

import CoreData

protocol ShoppingListDataProviderDelegate: AnyObject {
    func shoppingListDataProviderDidInsert(indexPath: IndexPath)
    func shoppingListDataProviderDidDelete(indexPath: IndexPath)
}

class ShoppingListDataProvider: NSObject {
    let fetchResultController: NSFetchedResultsController<ShoppingList>
    
    var sections: [NSFetchedResultsSectionInfo]? {
        fetchResultController.sections
    }

    weak var delegate: ShoppingListDataProviderDelegate?

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
            fatalError(error.localizedDescription)
        }
    }

    func object(at indexPath: IndexPath) -> ShoppingList {
        fetchResultController.object(at: indexPath)
    }
}

extension ShoppingListDataProvider: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let newIndexPath else {
            if let indexPath {
                delegate?.shoppingListDataProviderDidDelete(indexPath: indexPath)
            }
            return
        }
        delegate?.shoppingListDataProviderDidInsert(indexPath: newIndexPath)
    }
}
