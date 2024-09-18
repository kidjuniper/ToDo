//
//  AddingViewController.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation
import UIKit
import Lottie

protocol AddingViewProtocol: UIViewController {
    var presenter: AddingPresenterProtocol! { get set }
    
    func setUpWithDate(data: TaskModel)
    func makeCommentTextFieldFirstResponder()
}

class AddingViewController: UIViewController {
    var presenter: AddingPresenterProtocol!
    
    // MARK: - Private Properties
    private lazy var topLabel = makeTopLabel()
    private lazy var closerView = makeCloserView()
    private lazy var titleTextField = makeTitleTextField()
    private lazy var commentTextField = makeCommentTextField()
    private lazy var timeIntervalPicker = makeTimeIntervalPicker()
    private lazy var dateTextField = makeDateTextField()
    private lazy var saveButton = makeSaveButton()
    private let animationView = LottieAnimationView(name: K.addingModuleAnimationName)
    
    // MARK: - Initializer
    init(presenter: AddingPresenterProtocol? = nil) {
        super.init(nibName: nil,
                   bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
extension AddingViewController {
    private func setUp() {
        setUpLayout()
        setUpBackground()
        setUpTargets()
        setUpAnimation()
    }
    
    private func setUpLayout() {
        view.addSubviews(closerView,
                         topLabel,
                         titleTextField,
                         commentTextField,
                         dateTextField,
                         animationView,
                         saveButton)
        
        closerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(8)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(closerView.snp_bottomMargin).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp_bottomMargin).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp_bottomMargin).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp_bottomMargin).offset(30)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp_bottomMargin).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(260)
            make.height.equalTo(260)
        }
    }
    
    private func setUpAnimation() {
        animationView.loopMode = .loop
        animationView.play()
    }
    
    // MARK: - Actions
    private func setUpTargets() {
        saveButton.addTarget(self,
                             action: #selector(saveButtonTapped),
                             for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        presenter.updateCurrentTitle(withTitle: titleTextField.text ?? K.titleStringTemplate)
        presenter.updateCurrentComment(withText: commentTextField.text ?? K.commentStringTemplate)
        presenter.saveButtonTapped()
    }
}

extension AddingViewController: AddingViewProtocol {
    func makeCommentTextFieldFirstResponder() {
        commentTextField.becomeFirstResponder()
    }
    
    func setUpWithDate(data: TaskModel) {
        titleTextField.text = data.todo
        commentTextField.text = data.comment
    }
}

extension AddingViewController {
    private func makeCloserView() -> UIView {
        let closer = UIView()
        closer.layer.cornerRadius = 4
        closer.backgroundColor = .lightGray
        closer.clipsToBounds = true
        return closer
    }
    
    private func makeTopLabel() -> UILabel {
        let label = UILabel()
        label.font = K.boldFont
        label.textColor = .black
        label.textAlignment = .center
        label.text = "New task"
        return label
    }
    
    private func makeTitleTextField() -> TextField {
        let textField = TextField()
        textField.placeholder = "Enter tasks's name"
        textField.delegate = presenter
        textField.backgroundColor = K.baseBlueColor?.withAlphaComponent(0.55)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .whileEditing
        textField.tag = 1
        return textField
    }
    
    private func makeCommentTextField() -> TextField {
        let textField = TextField()
        textField.placeholder = "Enter tasks's comment"
        textField.delegate = presenter
        textField.backgroundColor = K.baseBlueColor?.withAlphaComponent(0.25)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .whileEditing
        textField.tag = 2
        return textField
    }
    
    private func makeDateTextField() -> TextField {
        let textField = TextField()
        textField.placeholder = "Select date and interval"
        textField.backgroundColor = K.baseBlueColor?.withAlphaComponent(0.45)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .never
        textField.returnKeyType = UIReturnKeyType.done
        textField.inputView = timeIntervalPicker.inputView
        return textField
    }
    
    private func makeTimeIntervalPicker() -> TimeIntervalPicker {
        let timeIntervalPicker = TimeIntervalPicker()
        timeIntervalPicker.setup()
        timeIntervalPicker.didSelectDates = { [weak self] (startDate,
                                                           endDate) in
            self?.presenter.updateCurrentDateInterval(startDate: startDate,
                                                      endDate: endDate)
            self?.dateTextField.text = startDate.formattedEventDate(to: endDate)
        }
        return timeIntervalPicker
    }
    
    private func makeSaveButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = K.baseBlueColor?.withAlphaComponent(0.15)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 7,
                                              bottom: 0,
                                              right: 0)
        button.setTitle("Save task",
                        for: .normal)
        button.setImage(UIImage(systemName: "rectangle.stack.badge.plus"),
                        for: .normal)
        button.setTitleColor(K.baseBlueColor,
                             for: .normal)
        button.tintColor = K.baseBlueColor
        return button
    }
}

