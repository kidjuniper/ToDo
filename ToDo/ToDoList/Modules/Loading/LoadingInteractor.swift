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
    var userDefaultsManager: UserDefaultManagerProtocol { get set }
}

final class LoadingInteractor: LoadingInteractorProtocol {
    weak var presenter: LoadingPresenterProtocol?
    var userDefaultsManager: UserDefaultManagerProtocol
    
    init(presenter: LoadingPresenterProtocol? = nil,
         userDefaultsManager: UserDefaultManagerProtocol) {
        self.presenter = presenter
        self.userDefaultsManager = userDefaultsManager
    }
    
    func checkIfItFirstLaunch() -> Bool {
        let isFirst = !(userDefaultsManager.fetchObject(type: Bool.self,
                                         for: .hasAlreadyBeenStarted) ?? false)
        return isFirst
    }
    
    func requestInitialData() {
        DummyjsonAPIManager().requestData { result in
            switch result {
            case .success(let tasks):
                self.presenter?.dataFetched(data: tasks)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestSavedData() {
        
    }
}
