//
//  LoadingRouterSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol LoadingRouterSpyProtocol: LoadingRouterProtocol {
    var presentMainPathCalled: Bool { get }
}

final class LoadingRouterSpy {
    var viewController: LoadingViewProtocol!
    private(set) var presentMainPathCalled = false
}

extension LoadingRouterSpy: LoadingRouterSpyProtocol {
    func presentListScreen(withData data: [TaskModel]) {
        presentMainPathCalled = true
    }
}
