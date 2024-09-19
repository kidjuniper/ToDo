//
//  LoadingRouter.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation
import UIKit

protocol LoadingRouterProtocol {
    func presentListScreen(withData data: [TaskModel])
    
    var viewController: LoadingViewProtocol! { get set }
}

final class LoadingRouter: LoadingRouterProtocol {
    weak var viewController: LoadingViewProtocol!
    private let storageManager: StorageManagerProtocol!
    
    init(viewController: LoadingViewProtocol? = nil,
         storageManager: StorageManagerProtocol) {
        self.viewController = viewController
        self.storageManager = storageManager
    }
    
    func presentListScreen(withData data: [TaskModel]) {
        let list = ListRouter.createModule(data: data,
                                           storageManager: storageManager)
        let rootViewController = UINavigationController(rootViewController: list)
        UIApplication.shared.windows.first?.rootViewController = rootViewController

    }
    
    static func createModule(userDefaultsManager: UserDefaultManagerProtocol,
                             storageManager: StorageManagerProtocol) -> LoadingViewProtocol {
        let view = LoadingViewController()
        let configurator = LoadingConfigurator()
        configurator.configure(view: view,
                               userDefaultsManager: userDefaultsManager,
                               storageManager: storageManager)
        return view
    }
}
