//
//  LoadingPresenterSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol LoadingPresenterSpyProtocol: LoadingPresenterProtocol {
    var viewDidLoadCalled: Bool { get }
    var dataFetchedCalled: Bool { get }
    var fetchedData: [TaskModel] { get }
}

final class LoadingPresenterSpy {
    var view: LoadingViewProtocol!
    var interactor: LoadingInteractorProtocol!
    var router: LoadingRouterProtocol!
    
    private(set) var viewDidLoadCalled = false
    private(set) var dataFetchedCalled = false
    private(set) var fetchedData: [TaskModel] = []
}

extension LoadingPresenterSpy: LoadingPresenterSpyProtocol {
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func dataFetched(data: [ToDo.TaskModel]) {
        dataFetchedCalled = true
        fetchedData = data
    }
}
