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

final class LoadingInteractor: LoadingInteractorProtocol {
    weak var presenter: LoadingPresenterProtocol?
    private var userDefaultsManager: UserDefaultManagerProtocol
    private var storageManager: StorageManagerProtocol
    
    init(presenter: LoadingPresenterProtocol? = nil,
         userDefaultsManager: UserDefaultManagerProtocol,
         storageManager: StorageManagerProtocol) {
        self.presenter = presenter
        self.userDefaultsManager = userDefaultsManager
        self.storageManager = storageManager
    }
    
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
                    self.storageManager.createTracker(with: model)
                }
                self.presenter?.dataFetched(data: tasks.todos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestSavedData() {
        self.presenter?.dataFetched(data: storageManager.getAllTrackers())
    }
}
