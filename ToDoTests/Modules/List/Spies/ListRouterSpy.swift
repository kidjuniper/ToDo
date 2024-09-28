//
//  ListRouterSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 28.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol ListRouterSpyProtocol: ListRouterProtocol {
    var presentAddingScreenCalled: Bool { get }
}

final class ListRouterSpy {
    var viewController: ListViewProtocol!
    private(set) var presentAddingScreenCalled = false
}

extension ListRouterSpy: ListRouterSpyProtocol {
    func presentAddingScreen(withData data: ToDo.TaskModel,
                             withMode mode: ToDo.AddingMode) {
        presentAddingScreenCalled = true
    }
}
