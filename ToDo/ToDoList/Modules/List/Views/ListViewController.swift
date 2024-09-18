//
//  ListViewController.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation
import UIKit
import SnapKit

protocol ListViewProtocol: UIViewController,
                           UICollectionViewDelegate,
                           UICollectionViewDelegateFlowLayout {
    var presenter: ListPresenterProtocol! { get set }
    
    func animateCell(indexPath: IndexPath,
                     completedSide: Bool)
    func reloadData()
}

class ListViewController: UIViewController {
    var presenter: ListPresenterProtocol! {
        didSet {
            collectionView.dataSource = presenter
            collectionView.delegate = self
        }
    }
    
    // MARK: - Private Properties
    private lazy var todayStack: UIStackView = makeTodaysStack()
    private lazy var topTodayLabel: UILabel = makeTopTodayLabel()
    private lazy var bottomTodayLabel: UILabel = makeBottomTodayLabel()
    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var createButton: UIButton = makeCreateButton()
    private lazy var topStack: UIStackView = makeTopStack()
    
    // MARK: - Initializer
    init(presenter: ListPresenterProtocol? = nil) {
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
extension ListViewController {
    private func setUp() {
        setUpBackground()
        setUpLayout()
    }
    
    private func setUpBackground() {
        view.backgroundColor = K.backgroundColor
    }
    
    private func setUpLayout() {
        view.addSubviews(topStack,
                         collectionView)
        
        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        createButton.snp.makeConstraints { make in
            make.width.equalTo(140)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayStack.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(60)
        }
    }
}

// MARK: - ListViewProtocol extension
extension ListViewController: ListViewProtocol {
    func animateCell(indexPath: IndexPath,
                     completedSide: Bool) {
        guard let okCell = collectionView.cellForItem(at: indexPath) as? AnimatableTaskCollectionViewCell else { return }
        if completedSide {
            okCell.reset(fast: false)
        }
        else {
            okCell.animate(fast: false)
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.9,
                      height: 190)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.tappedCell(indexPath: indexPath)
    }
}

// MARK: - Making UI
extension ListViewController {
    private func makeTodaysStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.addArrangedSubviews(topTodayLabel,
                                  bottomTodayLabel)
        return stack
    }
    
    private func makeTopTodayLabel() -> UILabel {
        let label = UILabel()
        label.font = K.boldFont
        label.textColor = .black
        label.text = "Today's Task"
        return label
    }
    
    private func makeBottomTodayLabel() -> UILabel {
        let label = UILabel()
        label.font = K.mainFont
        label.textColor = .lightGray
        label.text = "Wednesday, 11"
        return label
    }
    
    private func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(TaskCollectionViewCell.self,
                                forCellWithReuseIdentifier: TaskCollectionViewCell.reuseId)
        collectionView.backgroundColor = .clear
        flowLayout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }
    
    private func makeCreateButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = K.baseBlueColor?.withAlphaComponent(0.35)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.setTitle(" New Task",
                        for: .normal)
        button.setImage(UIImage(systemName: "plus"),
                        for: .normal)
        button.setTitleColor(K.baseBlueColor,
                             for: .normal)
        button.tintColor = K.baseBlueColor
        return button
    }
    
    private func makeTopStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 5
        stack.addArrangedSubviews(todayStack,
                                  createButton)
        return stack
    }
}
