//
//  AddingInteractor.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation

protocol AddingInteractorProtocol {
    var presenter: AddingPresenterProtocol! { get set }
    
    func save(task: TaskModel)
}

final class AddingInteractor: AddingInteractorProtocol {
    weak var presenter: AddingPresenterProtocol!
    
    // MARK: - Private Properties
    private var storageManager: StorageManagerProtocol
    private let mode: AddingMode
    
    // MARK: - Initializer
    init(presenter: AddingPresenterProtocol? = nil,
         storageManager: StorageManagerProtocol,
         addingMode: AddingMode) {
        self.presenter = presenter
        self.storageManager = storageManager
        self.mode = addingMode
    }
    
    func save(task: TaskModel) {
        switch mode {
        case .adding:
            storageManager.createTask(with: task)
        case .editing:
            storageManager.updateTaskData(withData: task)
        }
    }
}
