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

    let dataProvider: ShoppingListDataProvider
    let dataSource: ShoppingListDataSource

    init(dataProvider: ShoppingListDataProvider, dataSource: ShoppingListDataSource) {
        self.dataProvider = dataProvider
        self.dataSource = dataSource
        super.init(style: .plain)
        tableView.dataSource = dataSource
    }
    
    required init?(coder _: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.title.localized
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
}

extension TableViewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let shoppingList = NSEntityDescription.insertNewObject(
            forEntityName: TokenKeys.shoppingList.rawValue,
            into: dataProvider.fetchResultController.managedObjectContext.self
        ) as? ShoppingList {
            shoppingList.title = textField.text

            do {
                try dataProvider.fetchResultController.managedObjectContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
            textField.text = nil
            return textField.resignFirstResponder()
        }
        return false
    }
}
