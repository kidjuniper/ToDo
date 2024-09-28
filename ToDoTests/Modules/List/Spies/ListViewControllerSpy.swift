//
//  ListViewControllerSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 28.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol ListViewControllerSpyProtocol: ListViewProtocol {
    var reloadListCollectionCalled: Bool { get }
    var reloadSortingModeCollectionCalled: Bool { get }
    var animateCellCalled: Bool { get }
    var deleteTaskCalled: Bool { get }
    var setUpAsAllTasksCalled: Bool { get }
    var setUpAsTodaysTasksCalled: Bool { get }
}

final class ListViewControllerSpy: UIViewController {
    var presenter: ListPresenterProtocol!
    
    private(set) var reloadListCollectionCalled = false
    private(set) var reloadSortingModeCollectionCalled = false
    private(set) var animateCellCalled = false
    private(set) var deleteTaskCalled = false
    private(set) var setUpAsAllTasksCalled = false
    private(set) var setUpAsTodaysTasksCalled = false
}

extension ListViewControllerSpy: ListViewControllerSpyProtocol {
    func reloadListCollection() {
        reloadListCollectionCalled = true
    }
    
    func reloadSortingModeCollection() {
        reloadSortingModeCollectionCalled = true
    }
    
    func animateCell(on indexPath: IndexPath,
                     completedSide: Bool) {
        animateCellCalled = true
    }
    
    func deleteTask(on indexPath: IndexPath) {
        deleteTaskCalled = true
    }
    
    func setUpAsAllTasks() {
        setUpAsAllTasksCalled = true
    }
    
    func setUpAsTodaysTasks() {
        setUpAsTodaysTasksCalled = true
    }
}
