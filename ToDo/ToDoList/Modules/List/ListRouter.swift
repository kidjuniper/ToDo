//
//  ListRouter.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation

protocol ListRouterProtocol {
    static func createModule(data: Tasks) -> ListViewProtocol
    
    var viewController: ListViewProtocol! { get set }
}

final class ListRouter: ListRouterProtocol {
    weak var viewController: ListViewProtocol!
    
    init(viewController: ListViewProtocol? = nil) {
        self.viewController = viewController
    }
    static func createModule(data: Tasks)-> ListViewProtocol {
        let view = ListViewController()
        let configurator = ListConfigurator()
        configurator.configure(view: view,
                               data: data)
        return view
    }
}
