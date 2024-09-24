//
//  StorageManagerMock.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
import RxCocoa
import CoreData

@testable import ToDo

final class StorageManagerMock: StorageManagerProtocol {
    
    var storageRelay =  BehaviorRelay<[TaskModel]>(value: [])
    
    func createTask(with: TaskModel) {
        
    }
    
    func getAllTasks() -> [TaskModel] {
        return TaskModel.storageMockList
    }
    
    func getTasksForToday() -> [TaskModel] {
        return TaskModel.storageMockList
    }
    
    func deleteTask(by id: UUID) {
        
    }
    
    func updateTaskCompletion(by id: UUID) {
        
    }
    
    func updateTaskData(withData newData: TaskModel) {
        
    }
}
