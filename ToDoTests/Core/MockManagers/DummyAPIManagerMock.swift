//
//  DummyAPIManagerMock.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
@testable import ToDo

protocol DummyAPIManagerMockProtocol: DummyjsonAPIManagerProtocol {
    func setUpForSuccess()
    func setUpForFailure()
}

final class DummyAPIManagerMock: DummyAPIManagerMockProtocol {
    private var willSucceeded = false
    
    func setUpForSuccess() {
        willSucceeded = true
    }
    
    func setUpForFailure() {
        willSucceeded = false
    }
    
    func requestData(completion: @escaping (Result<ToDo.Tasks,
                                            ToDo.DummyjsonAPIError>) -> Void) {
        if willSucceeded {
            completion(.success(Tasks(todos: TaskModel.storageMockList)))
        }
        else {
            completion(.failure(.failedRequest))
        }
    }
}
