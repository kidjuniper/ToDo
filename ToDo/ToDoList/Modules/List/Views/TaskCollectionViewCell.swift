//
//  TaskCollectionViewCell.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation
import UIKit
import SnapKit
import Lottie

class TaskCollectionViewCell: UICollectionViewCell {
    private lazy var toDoLabel = makeToDoLabel()
    private lazy var commentLabel = makeCommentLabel()
    private lazy var topStack = makeTopStack()
    private let okAnimatedView = LottieAnimationView(name: "ok")
    private lazy var midStack = makeMidStack()
    private lazy var lineView = makeLineView()
    private lazy var mainStack = makeMainStack()
    let timeLabel = UILabel()
    
    static let reuseId = "TaskCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        setUpLayout()
        let selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView.backgroundColor = UIColor.lightGray
        self.selectedBackgroundView = selectedBackgroundView
        okAnimatedView.play()
    }
    
    func setUpLayout() {
        contentView.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        okAnimatedView.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        contentView.backgroundColor = .white
    }

    func configure(with task: TaskModel) {
        toDoLabel.text = task.todo
        commentLabel.text = task.comment
        timeLabel.text = ""
    }
}

extension TaskCollectionViewCell {
    private func makeToDoLabel() -> UILabel {
        let label = UILabel()
        label.font = K.mainFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }
    
    private func makeCommentLabel() -> UILabel {
        let label = UILabel()
        label.font = K.lightFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }
    
    private func makeTopStack() -> UIStackView {
        let stack = UIStackView()
        stack.addArrangedSubviews(toDoLabel,
                                  commentLabel)
        stack.axis = .vertical
        return stack
    }
    
    private func makeOkImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .blue
        return imageView
    }
    
    private func makeMidStack() -> UIStackView {
        let stack = UIStackView()
        stack.addArrangedSubviews(topStack,
                                  okAnimatedView)
        stack.spacing = 5
        stack.axis = .horizontal
        return stack
    }
    
    private func makeMainStack() -> UIStackView {
        let stack = UIStackView()
        stack.addArrangedSubviews(midStack,
                                  lineView)
        stack.spacing = 5
        stack.axis = .vertical
        return stack
    }
    
    private func makeLineView() -> UIView {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }
}
