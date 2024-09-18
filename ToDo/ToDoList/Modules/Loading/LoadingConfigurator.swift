//
//  LoadingConfigurator.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol LoadingConfiguratorProtocol {
    func configure(view: LoadingViewProtocol,
                   userDefaultsManager: UserDefaultManagerProtocol,
                   storageManager: StorageManagerProtocol)
}

final class LoadingConfigurator: LoadingConfiguratorProtocol {
    func configure(view: LoadingViewProtocol,
                   userDefaultsManager: UserDefaultManagerProtocol,
                   storageManager: StorageManagerProtocol) {
        let presenter = LoadingPresenter(view: view)
        let interactor = LoadingInteractor(presenter: presenter,
                                           userDefaultsManager: userDefaultsManager,
                                           storageManager: storageManager)
        let router = LoadingRouter(viewController: view,
                                   storageManager: storageManager)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
