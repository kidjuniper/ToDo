//
//  AddingRouter.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation
import UIKit

protocol AddingRouterProtocol {
    static func createModule(data: TaskModel,
                             storageManager: StorageManagerProtocol) -> AddingViewProtocol
    func dismiss()
}

final class AddingRouter: AddingRouterProtocol {
    weak var viewController: AddingViewProtocol!
    private let storageManager: StorageManagerProtocol!
    
    init(viewController: AddingViewProtocol? = nil,
         storageManager: StorageManagerProtocol) {
        self.viewController = viewController
        self.storageManager = storageManager
    }
    static func createModule(data: TaskModel,
                             storageManager: StorageManagerProtocol) -> AddingViewProtocol {
        let view = AddingViewController()
        let configurator = AddingConfigurator()
        configurator.configure(view: view,
                               data: data,
                               storageManager: storageManager)
        return view
    }
    
    func dismiss() {
        viewController.dismiss(animated: true)
    }
}
