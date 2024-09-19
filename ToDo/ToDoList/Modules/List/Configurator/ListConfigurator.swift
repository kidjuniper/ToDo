//
//  ListConfigurator.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation

protocol ListConfiguratorProtocol {
    func configure(view: ListViewProtocol,
                   data: [TaskModel],
                   storageManager: StorageManagerProtocol)
}

final class ListConfigurator: ListConfiguratorProtocol {
    func configure(view: ListViewProtocol,
                   data: [TaskModel],
                   storageManager: StorageManagerProtocol) {
        let presenter = ListPresenter(view: view,
                                      data: data)
        let interactor = ListInteractor(presenter: presenter,
                                        storageManager: storageManager)
        let router = ListRouter(viewController: view,
                                storageManager: storageManager)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
