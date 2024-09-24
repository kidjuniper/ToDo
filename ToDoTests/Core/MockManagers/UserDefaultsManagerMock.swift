//
//  UserDefaultsManagerMock.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
@testable import ToDo

protocol UserDefaultsManagerMockProtocol: UserDefaultManagerProtocol {
    func setUpAsFirst()
    func setUpAsNotFirst()
}

final class UserDefaultsManagerMock: UserDefaultsManagerMockProtocol {
    private var hasLaunched: Bool?
    
    func setUpAsFirst() {
        hasLaunched = false
    }
    
    func setUpAsNotFirst() {
        hasLaunched = true
    }
    
    func saveObject(_ value: Any, for key: ToDo.DefaultsKey) {}
    
    func fetchObject<T>(type: T.Type,
                        for key: ToDo.DefaultsKey) -> T? {
        if T.self == Bool.self {
            return hasLaunched as? T
        }
        else {
            fatalError("can't use that type for mocking user defaults manager")
        }
    }
    
    func deleteObject(for key: ToDo.DefaultsKey) {}
}
