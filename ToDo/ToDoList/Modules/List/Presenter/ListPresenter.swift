//
//  ListPresenter.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation
import UIKit

protocol ListPresenterProtocol: AnyObject,
                                UICollectionViewDataSource {
    func viewDidLoad()
    func tappedCell(indexPath: IndexPath)
    func addNewTapped()
    func dataUpdated(data: [TaskModel])
    func selectedSorting(indexPath: IndexPath)
    func changeMode()
    
    var view: ListViewProtocol! { get set }
    var interactor: ListInteractorProtocol! { get set }
    var router: ListRouterProtocol! { get set }
}

final class ListPresenter: NSObject,
                           UIContextMenuInteractionDelegate,
                           ListPresenterProtocol {
    var view: ListViewProtocol!
    var interactor: ListInteractorProtocol!
    var router: ListRouterProtocol!
    
    // MARK: - Private Properties
    private var tasks: [TaskModel] {
        didSet {
            tasksOpened = tasks.filter({ $0.completed == false })
            tasksClosed = tasks.filter({ $0.completed == true })
        }
    }
    private var tasksOpened: [TaskModel] = []
    private var tasksClosed: [TaskModel] = []
    private var selectedSortringModeIndex = 0
    private var today = false
    
    init(view: ListViewProtocol? = nil,
         interactor: ListInteractorProtocol? = nil,
         router: ListRouterProtocol? = nil,
         data: [TaskModel]) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.tasks = data
    }
    
    func viewDidLoad() {
        view.reloadListCollection()
    }
    
    func addNewTapped() {
        router.presentAddingScreen(withData: TaskModel(),
                                   withMode: .adding)
    }
    
    func dataUpdated(data: [TaskModel]) {
        tasks = data
        view.reloadListCollection()
    }
    
    func tappedCell(indexPath: IndexPath) {
        let index = indexPath.row
        let id = returnTasksWithSort()[index].id
        let completed = !returnTasksWithSort()[index].completed
        view.animateCell(on: indexPath,
                         completedSide: completed)
        view.reloadSortingModeCollection()
        switch selectedSortringModeIndex {
        case 2:
            view.deleteTask(on: indexPath)
        case 3:
            view.deleteTask(on: indexPath)
        default:
            break
        }
        interactor.changeStatus(by: id,
                                today: today)
    }
    
    func selectedSorting(indexPath: IndexPath) {
        if selectedSortringModeIndex != indexPath.row,
           selectedSortringModeIndex != 1 {
            selectedSortringModeIndex = indexPath.row
            view.reloadSortingModeCollection()
            view.reloadListCollection()
        }
    }
    
    func changeMode() {
        today = !today
        let _ = interactor.requestData(todays: today)
        if today {
            view.setUpAsTodaysTasks()
        }
        else {
            view.setUpAsAllTasks()
        }
    }
    
    private func returnTasksWithSort() -> [TaskModel] {
        switch selectedSortringModeIndex {
        case 0:
            return tasks
        case 2:
            return tasksOpened
        default:
            return tasksClosed
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        var tag = interaction.view?.tag ?? 0
        guard let cell = interaction.view as? IdentifiableCollectionViewCell else { return nil }
        let id = cell.uuid
        
        let editAction = UIAction(title: "Edit",
                                  image: UIImage(systemName: "pencil")) { _ in
            self.router.presentAddingScreen(withData: self.tasks[tag],
                                            withMode: .editing)
        }
        
        let deleteAction = UIAction(title: "Delete",
                                    image: UIImage(systemName: "trash"),
                                    attributes: .destructive) { _ in
            if self.returnTasksWithSort()[tag].id != id {
                tag -= 1
            }
            if self.returnTasksWithSort()[tag].id != id {
                tag += 2
            }
            self.view.deleteTask(on: IndexPath(row: tag,
                                               section: 0))
            self.deleteTracker(by: id)
            self.view.reloadListCollection()
            self.view.reloadSortingModeCollection()
        }
        
        let menu = UIMenu(title: "",
                          children: [editAction,
                                     deleteAction])
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
            return menu
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case K.listCollectionViewTag: returnTasksWithSort().count
        default:
            4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case K.listCollectionViewTag:
            let data = returnTasksWithSort()[indexPath.row]
            let cell = CollectionViewCellsFacroty.makeTaskCollectionViewCell(colletionView: collectionView,
                                                                  indexPath: indexPath,
                                                                  cellData: data)
            cell.tag = indexPath.row
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.addInteraction(interaction)
            return cell
            
        case K.sortingCollectionViewTag:
            let isSelected = indexPath.row == selectedSortringModeIndex
            var count = 0
            var dataId = indexPath.row
            switch indexPath.row {
            case 0:
                count = tasks.count
            case 2:
                count = tasksOpened.count
                dataId -= 1
            case 3:
                count = tasksClosed.count
                dataId -= 1
            default:
                break
            }
            let data = SortingCellModel(title: K.sortingModes[dataId],
                                        count: count,
                                        isSelected: isSelected)
            let cell = CollectionViewCellsFacroty.makeSortingCollectionViewCell(colletionView: collectionView,
                                                                                 indexPath: indexPath,
                                                                                 cellData: data)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func deleteTracker(by id: UUID) {
        interactor.deleteTracker(by: id)
    }
}
