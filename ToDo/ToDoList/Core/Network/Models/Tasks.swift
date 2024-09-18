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
struct TaskModel: Codable {
    var id: Int
    @DefaultTitleString
    var todo: String
    @DefaultFalse
    var completed: Bool
    @DefaultCommentString
    var comment: String
    @DefaultDate
    var startDate: Date
    @DefaultDate
    var endDate: Date
}
