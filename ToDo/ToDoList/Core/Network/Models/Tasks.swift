//
//  Tasks.swift
//  ToDo
//
//  Created by Nikita Stepanov on 16.09.2024.
//
import Foundation

// MARK: - Tasks
struct Tasks: Codable {
    @DefaultEmptyArray
    var todos: [TaskModel]
}

// MARK: - Task
struct TaskModel: Codable,
                  Equatable {
    @DefaultID
    var id: UUID
    @DefaultTitleString
    var todo: String
    @DefaultFalse
    var completed: Bool
    @DefaultEmptyString
    var comment: String
    @DefaultStartDate
    var startDate: Date
    @DefaultEndDate
    var endDate: Date
    
    init(from task: TrackerCoreData) {
        self.id = task.id ?? UUID()
        self.todo = task.toDo ?? ""
        self.comment = task.comment ?? ""
        self.startDate = task.startDate ?? Date()
        self.endDate = task.endDate ?? Date()
        self.completed = task.completed
    }
    
    init() {
        id = UUID()
        todo = ""
        completed = false
        comment = ""
        startDate = Date()
        endDate = Date()
    }
    
    static func == (lhs: Self,
                    rhs: Self) -> Bool {
        if lhs.id == rhs.id,
           lhs.comment == rhs.comment,
           lhs.todo == rhs.todo,
           lhs.startDate == rhs.startDate,
           lhs.endDate == rhs.endDate {
            return true
        }
        else {
            return false
        }
    }
}
