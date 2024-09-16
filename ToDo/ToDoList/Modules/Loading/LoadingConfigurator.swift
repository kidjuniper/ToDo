//
//  LoadingConfigurator.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol LoadingConfiguratorProtocol {
    func configure(view: LoadingViewProtocol,
                   userDefaultsManager: UserDefaultManagerProtocol)
}

final class LoadingConfigurator: LoadingConfiguratorProtocol {
    func configure(view: LoadingViewProtocol,
                   userDefaultsManager: UserDefaultManagerProtocol) {
        let presenter = LoadingPresenter(view: view)
        let interactor = LoadingInteractor(presenter: presenter,
                                           userDefaultsManager: userDefaultsManager)
        let router = LoadingRouter(viewController: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }

}
