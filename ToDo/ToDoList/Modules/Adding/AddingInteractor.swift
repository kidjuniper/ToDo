//
//  AddingInteractor.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation

protocol AddingInteractorProtocol {
    var presenter: AddingPresenterProtocol? { get set }
    var storageManager: StorageManagerProtocol { get set }
    
    func saveNewTask(task: TaskModel)
}

final class AddingInteractor: AddingInteractorProtocol {
    weak var presenter: AddingPresenterProtocol?
    var storageManager: StorageManagerProtocol
    
    // MARK: - Initializer
    init(presenter: AddingPresenterProtocol? = nil,
         storageManager: StorageManagerProtocol) {
        self.presenter = presenter
        self.storageManager = storageManager
    }
    
    func saveNewTask(task: TaskModel) {
        storageManager.createTracker(with: task)
    }
}
