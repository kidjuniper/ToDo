//
//  ListInteractorSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 28.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol ListInteractorSpyProtocol: ListInteractorProtocol {
    var deleteTrackerCalled: Bool { get }
    var changeStatusCalled: Bool { get }
    var requestDataCalled: Bool { get }
}

final class ListInteractorSpy {
    var presenter: ListPresenterProtocol!
    var storageManager: StorageManagerProtocol = StorageManagerMock()
    
    private(set) var deleteTrackerCalled = false
    private(set) var changeStatusCalled = false
    private(set) var requestDataCalled = false
}

extension ListInteractorSpy: ListInteractorSpyProtocol {
    func deleteTracker(by id: UUID) {
        deleteTrackerCalled = true
    }
    
    func changeStatus(by id: UUID,
                      today: Bool) {
        changeStatusCalled = true
    }
    
    func requestData(todays: Bool) -> [ToDo.TaskModel] {
        requestDataCalled = true
        return []
    }
}
