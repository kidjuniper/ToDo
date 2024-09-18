//
//  AddingConfigurator.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation

protocol AddingConfiguratorProtocol {
    func configure(view: AddingViewProtocol,
                   data: TaskModel,
                   storageManager: StorageManagerProtocol)
}

final class AddingConfigurator: AddingConfiguratorProtocol {
    func configure(view: AddingViewProtocol,
                   data: TaskModel,
                   storageManager: StorageManagerProtocol) {
        let presenter = AddingPresenter(view: view,
                                      data: data)
        let interactor = AddingInteractor(presenter: presenter,
                                          storageManager: storageManager)
        let router = AddingRouter(viewController: view,
                                  storageManager: storageManager)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
