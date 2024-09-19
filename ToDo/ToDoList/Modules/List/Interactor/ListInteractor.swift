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

final class ListInteractor: ListInteractorProtocol {
    weak var presenter: ListPresenterProtocol?
    var storageManager: StorageManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(presenter: ListPresenterProtocol,
         storageManager: StorageManagerProtocol) {
        self.presenter = presenter
        self.storageManager = storageManager
        setupBindings()
    }
    
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
        storageManager.deleteTracker(by: id)
    }
    
    func changeStatus(by id: UUID,
                      today: Bool) {
        storageManager.updateTrackerCompletion(by: id)
        presenter?.dataUpdated(data: today ? storageManager.getTasksForToday() : storageManager.getAllTrackers())
    }
    
    func requestData(todays: Bool) -> [TaskModel] {
        if todays {
            return storageManager.getTasksForToday()
        }
        else {
            return storageManager.getAllTrackers()
        }
    }
}
