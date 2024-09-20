//
//  ListInteractor.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation
import RxSwift

protocol ListInteractorProtocol {
    var presenter: ListPresenterProtocol? { get set }
    var storageManager: StorageManagerProtocol { get set }
    
    func deleteTracker(by id: UUID)
    func changeStatus(by id: UUID,
                      today: Bool)
    func requestData(todays: Bool) -> [TaskModel] 
}

final class ListInteractor {
    weak var presenter: ListPresenterProtocol?
    var storageManager: StorageManagerProtocol
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(presenter: ListPresenterProtocol,
         storageManager: StorageManagerProtocol) {
        self.presenter = presenter
        self.storageManager = storageManager
        setupBindings()
    }
}

// MARK: - ListInteractorProtocol extension
extension ListInteractor: ListInteractorProtocol {
    private func setupBindings() {
        storageManager.storageRelay
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                if let self = self {
                    presenter?.dataUpdated(data: data)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func deleteTracker(by id: UUID) {
        storageManager.deleteTask(by: id)
    }
    
    func changeStatus(by id: UUID,
                      today: Bool) {
        storageManager.updateTaskCompletion(by: id)
        presenter?.dataUpdated(data: today ? storageManager.getTasksForToday() : storageManager.getAllTasks())
    }
    
    func requestData(todays: Bool) -> [TaskModel] {
        if todays {
            return storageManager.getTasksForToday()
        }
        else {
            return storageManager.getAllTasks()
        }
    }
}
