//
//  ListConfigurator.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation

protocol ListConfiguratorProtocol {
    func configure(view: ListViewProtocol,
                   data: Tasks)
}

final class ListConfigurator: ListConfiguratorProtocol {
    func configure(view: ListViewProtocol,
                   data: Tasks) {
        let presenter = ListPresenter(view: view,
                                      data: data)
        let interactor = ListInteractor(presenter: presenter)
        let router = ListRouter(viewController: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
