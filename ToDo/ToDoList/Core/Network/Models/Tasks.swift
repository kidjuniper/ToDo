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
    var todos: [Task]
}

// MARK: - Todo
struct Task: Codable {
    var id: Int
    @DefaultTitleString
    var todo: String
    @DefaultFalse
    var completed: Bool
    @DefaultCommentString
    var comment: String
}
