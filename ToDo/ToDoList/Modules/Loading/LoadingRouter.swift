//
//  LoadingRouter.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol LoadingRouterProtocol {
    func presentMainScreen(withData data: [Int])
    
    var viewController: LoadingViewProtocol! { get set }
}

final class LoadingRouter: LoadingRouterProtocol {
    weak var viewController: LoadingViewProtocol!
    
    init(viewController: LoadingViewProtocol? = nil) {
        self.viewController = viewController
    }
    
    func presentMainScreen(withData data: [Int]) {
        
    }
    
    static func createModule(userDefaultsManager: UserDefaultManagerProtocol) -> LoadingView {
        let view = LoadingViewController()
        let configurator = LoadingConfigurator()
        configurator.configure(view: view,
                               userDefaultsManager: userDefaultsManager)
        return view
    }
}
