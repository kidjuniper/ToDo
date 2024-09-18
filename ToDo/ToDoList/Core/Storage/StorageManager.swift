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
    func deleteTracker(by id: UUID)
}

final class StorageManager: StorageManagerProtocol {
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private(set) var storageRelay = BehaviorRelay<[TaskModel]>(value: [])
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
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
    
    func deleteTracker(by id: UUID) {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@",
                                                 id as CVarArg)
            
            do {
                let trackerEntities = try context.fetch(fetchRequest)
                for trackerEntity in trackerEntities {
                    context.delete(trackerEntity)
                }
                saveContext()
                storageRelay.accept(self.getAllTrackers())
            } catch {
                fatalError("Failed to delete task: \(error)")
            }
        }
}
