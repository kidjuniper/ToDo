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

protocol AnimatableTaskCollectionViewCell: UICollectionViewCell {
    func animate(animate: Bool)
    func reset(animate: Bool)
}

protocol IdentifiableCollectionViewCell: UICollectionViewCell {
    var uuid: UUID { get set }
}

class TaskCollectionViewCell: UICollectionViewCell,
                              IdentifiableCollectionViewCell {
    private lazy var toDoLabel = makeToDoLabel()
    private lazy var commentLabel = makeCommentLabel()
    private lazy var topStack = makeTopStack()
    private let okAnimatedView = LottieAnimationView(name: "ok")
    private lazy var midStack = makeMidStack()
    private lazy var lineView = makeLineView()
    private lazy var mainStack = makeMainStack()
    private lazy var timeLabel = makeTimeLabel()
    var uuid = UUID()
    
    static let reuseId = "TaskCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        interactions.removeAll()
    }

    func setUp() {
        setUpLayout()
        let selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView.backgroundColor = UIColor.lightGray
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func setUpLayout() {
        contentView.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        okAnimatedView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.greaterThanOrEqualTo(60)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        contentView.backgroundColor = .white
    }

    func configure(with task: TaskModel) {
        toDoLabel.text = task.todo
        commentLabel.text = task.comment
        timeLabel.text = task.startDate.formattedEventDate(to: task.endDate)
        uuid = task.id
        if task.completed {
            self.animate(animate: false)
        }
        else {
            reset(animate: false)
        }
    }
}

extension TaskCollectionViewCell: AnimatableTaskCollectionViewCell {
    func animate(animate: Bool = false) {
        okAnimatedView.animationSpeed = animate ? 1 : 100
        okAnimatedView.play()
    }
    
    func reset(animate: Bool = false) {
        okAnimatedView.animationSpeed = animate ? 1 : 100
        okAnimatedView.stop()
        okAnimatedView.play(toFrame: 10)
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
        stack.distribution = .fillProportionally
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
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .horizontal
        return stack
    }
    
    private func makeMainStack() -> UIStackView {
        let stack = UIStackView()
        stack.addArrangedSubviews(midStack,
                                  lineView,
                                  timeLabel)
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        return stack
    }
    
    private func makeLineView() -> UIView {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }
    
    private func makeTimeLabel() -> UILabel {
        let label = UILabel()
        label.font = K.lightFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }
}
