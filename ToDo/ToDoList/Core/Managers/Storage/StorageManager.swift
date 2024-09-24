//
//  Storage.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//
import Foundation
import CoreData
import RxSwift
import RxRelay

protocol StorageManagerProtocol {
    var storageRelay: BehaviorRelay<[TaskModel]> { get }
    
    func createTask(with: TaskModel)
    func getAllTasks() -> [TaskModel]
    func getTasksForToday() -> [TaskModel]
    func deleteTask(by id: UUID)
    func updateTaskCompletion(by id: UUID)
    func updateTaskData(withData newData: TaskModel)
}

final class StorageManager: StorageManagerProtocol {
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private(set) var storageRelay = BehaviorRelay<[TaskModel]>(value: [])
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Storage")
        container.loadPersistentStores(completionHandler: { (_,
                                                             error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Create Methods
    func createTask(with taskModel: TaskModel) {
        let taskEntity = TrackerCoreData(context: context)
        taskEntity.id = taskModel.id
        taskEntity.toDo = taskModel.todo
        taskEntity.completed = taskModel.completed
        taskEntity.comment = taskModel.comment
        taskEntity.startDate = taskModel.startDate
        taskEntity.endDate = taskModel.endDate
        saveContext()
        storageRelay.accept(self.getAllTasks())
    }
    
    // MARK: - Get Methods
    private func getTracker(by id: UUID) -> TaskModel? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@",
                                             id as CVarArg)
        
        do {
            guard let tracker = try context.fetch(fetchRequest).first else {
                return nil
            }
            return TaskModel(from: tracker)
        }
        catch {
            return nil
        }
    }
    
    func getAllTasks() -> [TaskModel] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let tasksEntities = try context.fetch(fetchRequest)
            let tasks = tasksEntities.map { TaskModel(from: $0) }
            storageRelay.accept(tasks)
            return tasksEntities.map { TaskModel(from: $0) }
        } catch {
            return []
        }
    }
    
    func getTasksForToday() -> [TaskModel] {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!
        
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "startDate >= %@ AND startDate < %@",
                                             todayStart as NSDate,
                                             todayEnd as NSDate)
        do {
            let tasksEntities = try context.fetch(fetchRequest)
            let tasks = tasksEntities.map { TaskModel(from: $0) }
            storageRelay.accept(tasks)
            return tasksEntities.map { TaskModel(from: $0) }
        } catch {
            return []
        }
    }
    
    // MARK: - Delete Methods
    func deleteTask(by id: UUID) {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@",
                                                 id as CVarArg)
            do {
                let tasksEntities = try context.fetch(fetchRequest)
                if let taskEntity = tasksEntities.first {
                    context.delete(taskEntity)
                }
                saveContext()
                self.storageRelay.accept(self.getAllTasks())
            } catch {
                fatalError("Failed to delete task: \(error)")
            }
        }
    
    // MARK: - Update Methods
    func updateTaskCompletion(by id: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@",
                                             id as CVarArg)
        do {
            let tasksEntities = try context.fetch(fetchRequest)
            if let taskEntity = tasksEntities.first {
                taskEntity.completed = !taskEntity.completed
            }
            saveContext()
            self.storageRelay.accept(self.getAllTasks())
        } catch {
            fatalError("Failed to update tracker completion: \(error)")
        }
    }
    
    func updateTaskData(withData newData: TaskModel) {
        let id = newData.id
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@",
                                             id as CVarArg)
        do {
            let tasksEntities = try context.fetch(fetchRequest)
            if let taskEntity = tasksEntities.first {
                taskEntity.toDo = newData.todo
                taskEntity.comment = newData.comment
                taskEntity.startDate = newData.startDate
                taskEntity.endDate = newData.endDate
            }
            saveContext()
            storageRelay.accept(self.getAllTasks())
        } catch {
            fatalError("Failed to update tracker completion: \(error)")
        }
    }
}
