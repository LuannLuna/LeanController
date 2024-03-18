//
//  SceneDelegate.swift
//  LeanController
//
//  Created by Luann Luna on 15/03/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coreData: CoreDataManager?

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
        coreData = CoreDataManager()

        let vc = TableViewViewController().with {
            $0.managedObjectContext = coreData?.managedObjectContext
        }
        let nav = UINavigationController(rootViewController: vc)

        return UIWindow(windowScene: windowScene).with {
            $0.rootViewController = nav
        }
    }
}
