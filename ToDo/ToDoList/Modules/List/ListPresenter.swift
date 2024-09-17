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
    private var tasks: Tasks
    
    init(view: ListViewProtocol? = nil,
         interactor: ListInteractorProtocol? = nil,
         router: ListRouterProtocol? = nil,
         data: Tasks) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.tasks = data
    }
    
    func viewDidLoad() {
        view.reloadData()
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            let editAction = UIAction(title: "Edit",
                                      image: UIImage(systemName: "pencil")) { _ in

            }

            let deleteAction = UIAction(title: "Delete",
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { _ in

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
        tasks.todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.reuseId,
                                                      for: indexPath) as! TaskCollectionViewCell
        cell.configure(with: tasks.todos[indexPath.row])
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        return cell
    }
}
