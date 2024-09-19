//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let userDefaultsManager = UserDefaultManager()
    let storageManager = StorageManager()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        returnLoadingViewController(withScene: windowScene)
    }
}

extension SceneDelegate {
    private func returnLoadingViewController(withScene scene: UIWindowScene) {
        let viewController = LoadingRouter.createModule(userDefaultsManager: userDefaultsManager,
                                                        storageManager: storageManager)
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
}
