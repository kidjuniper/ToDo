//
//  UserDefaultsManager.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol UserDefaultManagerProtocol {
    func saveObject(_ value: Any,
        for key: DefaultsKey)
    func fetchObject<T>(type: T.Type,
        for key: DefaultsKey) ->T?
    func deleteObject(for key: DefaultsKey)
}

final class UserDefaultManager {
    private let defaults = UserDefaults.standard
}

extension UserDefaultManager: UserDefaultManagerProtocol {
    func saveObject(_ value: Any,
        for key: DefaultsKey) {
        defaults.set(
            value,
            forKey: key.rawValue
        )
    }
    
    func fetchObject<T>(type: T.Type,
        for key: DefaultsKey) ->T? {
        return defaults.object(forKey: key.rawValue) as? T
    }
    
    func deleteObject(for key: DefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}

enum DefaultsKey: String {
    case hasAlreadyBeenStarted
}
