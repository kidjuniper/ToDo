//
//  LoadingInteractor.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol LoadingInteractorProtocol {
    func requestData()
    
    var presenter: LoadingPresenterProtocol! { get set }
}

final class LoadingInteractor {
    weak var presenter: LoadingPresenterProtocol!
    
    // MARK: - Private Properties
    private var userDefaultsManager: UserDefaultManagerProtocol
    private var storageManager: StorageManagerProtocol
    private var dummyAPIManager: DummyjsonAPIManagerProtocol
    
    // MARK: - Initializer
    init(presenter: LoadingPresenterProtocol? = nil,
         userDefaultsManager: UserDefaultManagerProtocol,
         storageManager: StorageManagerProtocol,
         dummyAPIManager: DummyjsonAPIManagerProtocol) {
        self.presenter = presenter
        self.userDefaultsManager = userDefaultsManager
        self.storageManager = storageManager
        self.dummyAPIManager = dummyAPIManager
    }
}

// MARK: - LoadingInteractorProtocol extension
extension LoadingInteractor: LoadingInteractorProtocol {
    func requestData() {
        if checkIfItFirstLaunch() {
            requestInitialData()
        }
        else {
            requestSavedData()
        }
    }
    
    private func checkIfItFirstLaunch() -> Bool {
        let isFirst = !(userDefaultsManager.fetchObject(type: Bool.self,
                                         for: .hasAlreadyBeenStarted) ?? false)
        userDefaultsManager.saveObject(true,
                                       for: .hasAlreadyBeenStarted)
        return isFirst
    }
    
    private func requestInitialData() {
        dummyAPIManager.requestData { result in
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
    
    private func requestSavedData() {
        self.presenter?.dataFetched(data: storageManager.getAllTasks())
    }
}
