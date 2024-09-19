//
//  SortingCell.swift
//  ToDo
//
//  Created by Nikita Stepanov on 19.09.2024.
//

import Foundation
import UIKit

class SortingCollectionViewCell: UICollectionViewCell {
    static let reuseId = "SortingCollectionViewCell"
    
    private lazy var theTitleLabel = makeTitleLabel()
    private lazy var countLabel = makeCountLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        setUpLayout()
    }
    
    func setUpLayout() {
        contentView.addSubview(theTitleLabel)
        theTitleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
    }

    func configure(with data: SortingCellModel) {
        theTitleLabel.text = data.title
        countLabel.text = "\(data.count)"
        if data.isSelected {
            select()
        }
        else {
            deselect()
        }
    }
    
    func select() {
        theTitleLabel.textColor = K.baseBlueColor
        countLabel.backgroundColor = K.baseBlueColor
    }
    
    func deselect() {
        theTitleLabel.textColor = .lightGray
        countLabel.backgroundColor = .lightGray
    }
}

struct SortingCellModel {
    let title: String
    let count: Int
    let isSelected: Bool
}

extension SortingCollectionViewCell {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = K.mainFont
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }
    
    func makeCountLabel() -> UILabel {
        let label = UILabel()
        label.font = K.mainFont
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.textColor = K.backgroundColor
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }
}
