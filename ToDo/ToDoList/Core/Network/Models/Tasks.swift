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
    
    init(todos: [TaskModel]) {
        self.todos = todos
    }
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
    @DefaultCommentString
    var comment: String
    @DefaultStartDate
    var startDate: Date
    @DefaultEndDate
    var endDate: Date
    
    // for testing
    @DefaultTaskModelType
    var type: TaskModelType
    
    
    init(from task: TrackerCoreData) {
        self.id = task.id ?? UUID()
        self.todo = task.toDo ?? ""
        self.comment = task.comment ?? ""
        self.startDate = task.startDate ?? Date()
        self.endDate = task.endDate ?? Date()
        self.completed = task.completed
        self.type = .organic
    }
    
    init(_ withMode: TaskModelType = .organic) {
        id = UUID()
        todo = ""
        completed = false
        comment = ""
        startDate = Date()
        endDate = Date()
        type = withMode
    }
    
    static func == (lhs: Self,
                    rhs: Self) -> Bool {
        // althought 'completed' properties are different, models are the same
        if lhs.id == rhs.id,
           lhs.comment == rhs.comment,
           lhs.todo == rhs.todo,
           lhs.startDate == rhs.startDate,
           lhs.endDate == rhs.endDate {
            return true
        }
        else if lhs.type == .apiMock,
           rhs.type == .apiMock {
            return true
        }
        else if lhs.type == .storageMock,
           rhs.type == .storageMock {
            return true
        }
        else {
            return false
        }
    }
    
    static var apiMockList: [TaskModel] {
        var mockTask = TaskModel(.apiMock)
        return [mockTask]
    }
    
    static var storageMockList: [TaskModel] {
        var mockTask = TaskModel(.storageMock)
        return [mockTask]
    }
}

public enum TaskModelType: Codable {
    case organic
    case apiMock
    case storageMock
}
