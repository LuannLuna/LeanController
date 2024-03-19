//
//  SceneDelegate.swift
//  LeanController
//
//  Created by Luann Luna on 15/03/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = initializeScene(windowScene: windowScene)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}

extension SceneDelegate {
    func initializeScene(windowScene: UIWindowScene) -> UIWindow {
        let coreData = CoreDataManager()
        let provider = ShoppingListDataProvider(managedObjectContext: coreData.managedObjectContext)
        let dataSource = ShoppingListDataSource(dataProvider: provider)

        let vc = TableViewViewController(
            dataProvider: provider,
            dataSource: dataSource
        )
        dataSource.tableView = vc.tableView

        let nav = UINavigationController(rootViewController: vc)
        return UIWindow(windowScene: windowScene).with {
            $0.rootViewController = nav
        }
    }
}
