//
//  ListPresenterSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 28.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol ListPresenterSpyProtocol: ListPresenterProtocol {
    var viewDidLoadCalled: Bool { get }
    var addNewTappedCalled: Bool { get }
    var dataUpdatedCalled: Bool { get }
    var tappedCellCalled: Bool { get }
    var selectedSortingCalled: Bool { get }
    var changeModeCalled: Bool { get }
}

final class ListPresenterSpy: NSObject {
    var view: ListViewProtocol!
    var interactor: ListInteractorProtocol!
    var router: ListRouterProtocol!
    
    private(set) var viewDidLoadCalled = false
    private(set) var addNewTappedCalled = false
    private(set) var dataUpdatedCalled = false
    private(set) var tappedCellCalled = false
    private(set) var selectedSortingCalled = false
    private(set) var changeModeCalled = false
}

extension ListPresenterSpy: ListPresenterSpyProtocol {
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func addNewTapped() {
        addNewTappedCalled = true
    }
    
    func dataUpdated(data: [ToDo.TaskModel]) {
        dataUpdatedCalled = true
    }
    
    func tappedCell(indexPath: IndexPath) {
        tappedCellCalled = true
    }
    
    func selectedSorting(indexPath: IndexPath) {
        selectedSortingCalled = true
    }
    
    func changeMode() {
        changeModeCalled = true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { return 0 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { return UICollectionViewCell() }
}
