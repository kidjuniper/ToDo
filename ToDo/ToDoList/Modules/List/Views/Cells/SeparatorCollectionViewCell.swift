//
//  SeparatorCollectionViewCell.swift
//  ToDo
//
//  Created by Nikita Stepanov on 19.09.2024.
//

import Foundation
import UIKit

class SeparatorCollectionViewCell: UICollectionViewCell {
    static let reuseId = "SeparatorCollectionViewCell"
    
    private lazy var lineView = makeLineView()

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
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension SeparatorCollectionViewCell {
    func makeLineView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }
}
