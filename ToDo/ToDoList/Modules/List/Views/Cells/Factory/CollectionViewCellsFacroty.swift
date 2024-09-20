//
//  CollectionViewCellsFacroty.swift
//  ToDo
//
//  Created by Nikita Stepanov on 19.09.2024.
//

import Foundation
import UIKit


enum CollectionViewCellsFacroty {
    static func makeSortingCollectionViewCell(colletionView: UICollectionView,
                                                indexPath: IndexPath,
                                                cellData: SortingCellModel) -> UICollectionViewCell {
        if indexPath.row == 1 {
            let reuseId = SeparatorCollectionViewCell.reuseId
            guard let cell = colletionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                               for: indexPath) as? SeparatorCollectionViewCell else {
                fatalError("Unable to dequeue SeparatorCollectionViewCell")
            }
            return cell
        }
        else {
            let reuseId = SortingCollectionViewCell.reuseId
            guard let cell = colletionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                               for: indexPath) as? SortingCollectionViewCell else {
                fatalError("Unable to dequeue SortingCollectionViewCell")
            }
            cell.configure(with: cellData)
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            return cell
        }
    }
    
    static func makeTaskCollectionViewCell(colletionView: UICollectionView,
                                                indexPath: IndexPath,
                                                cellData: TaskModel) -> UICollectionViewCell {
        let reuseId = TaskCollectionViewCell.reuseId
        guard let cell = colletionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                           for: indexPath) as? TaskCollectionViewCell else {
            fatalError("Unable to dequeue TaskCollectionViewCell")
        }
        cell.configure(with: cellData)
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        return cell
    }
}
