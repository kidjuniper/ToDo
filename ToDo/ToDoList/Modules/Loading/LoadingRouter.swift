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

final class LoadingRouter {
    weak var viewController: LoadingViewProtocol!
    
    // MARK: - Private Properties
    private let storageManager: StorageManagerProtocol!
    
    // MARK: - Initializer
    init(viewController: LoadingViewProtocol? = nil,
         storageManager: StorageManagerProtocol) {
        self.viewController = viewController
        self.storageManager = storageManager
    }
}

// MARK: - LoadingRouterProtocol extension
extension LoadingRouter: LoadingRouterProtocol {
    func presentListScreen(withData data: [TaskModel]) {
        let list = ListRouter.createModule(data: data,
                                           storageManager: storageManager)
        let rootViewController = UINavigationController(rootViewController: list)
        UIApplication.shared.windows.first?.rootViewController = rootViewController

    }
    
    static func createModule(userDefaultsManager: UserDefaultManagerProtocol,
                             storageManager: StorageManagerProtocol,
                             dummyAPIManager: DummyjsonAPIManagerProtocol) -> LoadingViewProtocol {
        let view = LoadingViewController()
        let configurator = LoadingConfigurator()
        configurator.configure(view: view,
                               userDefaultsManager: userDefaultsManager,
                               storageManager: storageManager,
                               dummyAPIManager: dummyAPIManager)
        return view
    }
}
