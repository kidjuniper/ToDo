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
    private var tasks: [TaskModel]
    private var selectedIndexPath: IndexPath?
    
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
        view.reloadData()
    }
    
    func addNewTapped() {
        router.presentAddingScreen(withData: TaskModel())
    }
    
    func dataUpdated(data: [TaskModel]) {
        tasks = data
        view.reloadData()
    }
    
    func tappedCell(indexPath: IndexPath) {
        let index = indexPath.row
        let completed = tasks[index].completed
        view.animateCell(indexPath: indexPath,
                         completedSide: completed)
        tasks[index].completed = !completed
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let tag = interaction.view?.tag ?? 0
        let taskId = tasks[tag].id
        
        let editAction = UIAction(title: "Edit",
                                  image: UIImage(systemName: "pencil")) { _ in
            // Handle edit action
        }
        
        let deleteAction = UIAction(title: "Delete",
                                    image: UIImage(systemName: "trash"),
                                    attributes: .destructive) { _ in
            self.deleteTracker(by: taskId)
            print(taskId)
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
        tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.reuseId,
                                                      for: indexPath) as! TaskCollectionViewCell
        cell.configure(with: tasks[indexPath.row])
        cell.tag = indexPath.row
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        selectedIndexPath = indexPath
        
        return cell
    }
    
    private func deleteTracker(by id: UUID) {
        interactor.deleteTracker(by: id)
    }
}
