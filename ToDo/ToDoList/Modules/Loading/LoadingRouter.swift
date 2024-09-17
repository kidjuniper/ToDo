//
//  LoadingRouter.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation
import UIKit

protocol LoadingRouterProtocol {
    func presentListScreen(withData data: Tasks)
    
    var viewController: LoadingViewProtocol! { get set }
}

final class LoadingRouter: LoadingRouterProtocol {
    weak var viewController: LoadingViewProtocol!
    
    init(viewController: LoadingViewProtocol? = nil) {
        self.viewController = viewController
    }
    
    func presentListScreen(withData data: Tasks) {
        let list = ListRouter.createModule(data: data)
        let rootViewController = UINavigationController(rootViewController: list)
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        if let windowScene = scene as? UIWindowScene { windowScene.keyWindow?.rootViewController = rootViewController
        }
    }
    
    static func createModule(userDefaultsManager: UserDefaultManagerProtocol) -> LoadingViewProtocol {
        let view = LoadingViewController()
        let configurator = LoadingConfigurator()
        configurator.configure(view: view,
                               userDefaultsManager: userDefaultsManager)
        return view
    }
}
