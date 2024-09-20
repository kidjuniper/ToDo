//
//  LoadingInteractor.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol LoadingInteractorProtocol {
    func checkIfItFirstLaunch() -> Bool
    func requestInitialData()
    func requestSavedData()
    
    var presenter: LoadingPresenterProtocol? { get set }
}

final class LoadingInteractor {
    weak var presenter: LoadingPresenterProtocol?
    
    // MARK: - Private Properties
    private var userDefaultsManager: UserDefaultManagerProtocol
    private var storageManager: StorageManagerProtocol
    
    // MARK: - Initializer
    init(presenter: LoadingPresenterProtocol? = nil,
         userDefaultsManager: UserDefaultManagerProtocol,
         storageManager: StorageManagerProtocol) {
        self.presenter = presenter
        self.userDefaultsManager = userDefaultsManager
        self.storageManager = storageManager
    }
}

// MARK: - LoadingInteractorProtocol extension
extension LoadingInteractor: LoadingInteractorProtocol {
    func checkIfItFirstLaunch() -> Bool {
        let isFirst = !(userDefaultsManager.fetchObject(type: Bool.self,
                                         for: .hasAlreadyBeenStarted) ?? false)
        userDefaultsManager.saveObject(true,
                                       for: .hasAlreadyBeenStarted)
        return isFirst
    }
    
    func requestInitialData() {
        DummyjsonAPIManager().requestData { result in
            switch result {
            case .success(let tasks):
                tasks.todos.forEach { model in
                    self.storageManager.createTask(with: model)
                }
                self.presenter?.dataFetched(data: tasks.todos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestSavedData() {
        self.presenter?.dataFetched(data: storageManager.getAllTasks())
    }
}
