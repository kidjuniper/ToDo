//
//  ListRouter.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation

protocol ListRouterProtocol {
    static func createModule(data: [TaskModel],
                             storageManager: StorageManagerProtocol) -> ListViewProtocol
    func presentAddingScreen(withData data: TaskModel,
                             withMode mode: AddingMode)
    
    var viewController: ListViewProtocol! { get set }
}

final class ListRouter: ListRouterProtocol {
    weak var viewController: ListViewProtocol!
    private let storageManager: StorageManagerProtocol!
    
    init(viewController: ListViewProtocol? = nil,
         storageManager: StorageManagerProtocol) {
        self.viewController = viewController
        self.storageManager = storageManager
    }
    static func createModule(data: [TaskModel],
                             storageManager: StorageManagerProtocol) -> ListViewProtocol {
        let view = ListViewController()
        let configurator = ListConfigurator()
        configurator.configure(view: view,
                               data: data,
                               storageManager: storageManager)
        return view
    }
    
    func presentAddingScreen(withData data: TaskModel,
                             withMode mode: AddingMode) {
        let list = AddingRouter.createModule(data: data,
                                             storageManager: storageManager,
                                             addingMode: mode)
        list.modalPresentationStyle = .pageSheet
        viewController.present(list,
                               animated: true)
    }
}
