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
    var context: NSManagedObjectContext { get }
    var storageRelay: BehaviorRelay<[TaskModel]> { get }
    
    func createTracker(with tracker: TaskModel)
    func getAllTrackers() -> [TaskModel]
    func getTasksForToday() -> [TaskModel]
    func deleteTracker(by id: UUID)
    func updateTrackerCompletion(by id: UUID)
    func updateTrackerData(withData newData: TaskModel)
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
    func createTracker(with tracker: TaskModel) {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.toDo = tracker.todo
        trackerEntity.completed = tracker.completed
        trackerEntity.comment = tracker.comment
        trackerEntity.startDate = tracker.startDate
        trackerEntity.endDate = tracker.endDate
        saveContext()
        storageRelay.accept(self.getAllTrackers())
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
    
    func getAllTrackers() -> [TaskModel] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let trackerEntities = try context.fetch(fetchRequest)
            let tasks = trackerEntities.map { TaskModel(from: $0) }
            storageRelay.accept(tasks)
            return trackerEntities.map { TaskModel(from: $0) }
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
            let trackerEntities = try context.fetch(fetchRequest)
            let tasks = trackerEntities.map { TaskModel(from: $0) }
            storageRelay.accept(tasks)
            return trackerEntities.map { TaskModel(from: $0) }
        } catch {
            return []
        }
    }
    
    func deleteTracker(by id: UUID) {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@",
                                                 id as CVarArg)
            do {
                let trackerEntities = try context.fetch(fetchRequest)
                if let trackerEntity = trackerEntities.first {
                    context.delete(trackerEntity)
                }
                saveContext()
                self.storageRelay.accept(self.getAllTrackers())
            } catch {
                fatalError("Failed to delete task: \(error)")
            }
        }
    
    func updateTrackerCompletion(by id: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@",
                                             id as CVarArg)
        do {
            let trackerEntities = try context.fetch(fetchRequest)
            if let trackerEntity = trackerEntities.first {
                trackerEntity.completed = !trackerEntity.completed
            }
            saveContext()
            self.storageRelay.accept(self.getAllTrackers())
        } catch {
            fatalError("Failed to update tracker completion: \(error)")
        }
    }
    
    func updateTrackerData(withData newData: TaskModel) {
        let id = newData.id
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@",
                                             id as CVarArg)
        
        do {
            let trackerEntities = try context.fetch(fetchRequest)
            if let trackerEntity = trackerEntities.first {
                trackerEntity.toDo = newData.todo
                trackerEntity.comment = newData.comment
                trackerEntity.startDate = newData.startDate
                trackerEntity.endDate = newData.endDate
            }
            saveContext()
            storageRelay.accept(self.getAllTrackers())
        } catch {
            fatalError("Failed to update tracker completion: \(error)")
        }
    }
}
