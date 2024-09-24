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
    
    func reloadListCollection()
    func reloadSortingModeCollection()
    func animateCell(on indexPath: IndexPath,
                     completedSide: Bool)
    func deleteTask(on indexPath: IndexPath)
    func setUpAsAllTasks()
    func setUpAsTodaysTasks()
}

class ListViewController: UIViewController {
    var presenter: ListPresenterProtocol! {
        didSet {
            listCollectionView.dataSource = presenter
            listCollectionView.delegate = self
            sortingCollectionView.dataSource = presenter
            sortingCollectionView.delegate = self
        }
    }
    
    // MARK: - Private Properties
    private lazy var todayStack: UIStackView = makeTodaysStack()
    private lazy var topTodayLabel: UILabel = makeTopTodayLabel()
    private lazy var bottomTodayLabel: UILabel = makeBottomTodayLabel()
    private lazy var sortingCollectionView: UICollectionView = makeSortingCollectionView()
    private lazy var listCollectionView: UICollectionView = makeCollectionView()
    private lazy var createButton: UIButton = makeCreateButton()
    private lazy var topStack: UIStackView = makeTopStack()
    
    // MARK: - Initializer
    init(presenter: ListPresenterProtocol? = nil) {
        super.init(nibName: nil,
                   bundle: nil)
        self.presenter = presenter
        self.navigationController?.navigationBar.isHidden = true
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
        setUpTargets()
    }
    
    private func setUpLayout() {
        view.addSubviews(topStack,
                         sortingCollectionView,
                         listCollectionView)
        
        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(K.topSpace)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        sortingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(todayStack.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        createButton.snp.makeConstraints { make in
            make.width.equalTo(140)
        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(K.bottomSpace)
        }
    }
    
    // MARK: - Actions
    private func setUpTargets() {
        createButton.addTarget(self,
                               action: #selector(createButtonTapped),
                               for: .touchUpInside)
    }
    
    @objc func createButtonTapped() {
        presenter.addNewTapped()
    }
    
    @objc private func modeSelectorTapped() {
        presenter.changeMode()
    }
}

// MARK: - ListViewProtocol extension
extension ListViewController: ListViewProtocol {
    func setUpAsAllTasks() {
        topTodayLabel.text = "All Tasks"
        bottomTodayLabel.text = "On one page"
    }
    
    func setUpAsTodaysTasks() {
        topTodayLabel.text = "Today's tasks"
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d"
        let formattedDate = dateFormatter.string(from: today)
        bottomTodayLabel.text = formattedDate
    }
    
    func deleteTask(on indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.listCollectionView.deleteItems(at: [indexPath])
        }
    }
    
    func animateCell(on indexPath: IndexPath,
                     completedSide: Bool) {
        guard let okCell = listCollectionView.cellForItem(at: indexPath) as? AnimatableTaskCollectionViewCell else { return }
        if completedSide {
            okCell.animate(animate: true)
        }
        else {
            okCell.reset(animate: true)
        }
    }
    
    func reloadListCollection() {
        DispatchQueue.main.async {
            self.listCollectionView.reloadData()
        }
    }
    
    func reloadSortingModeCollection() {
        DispatchQueue.main.async {
            self.sortingCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case K.tags.listCollectionViewTag.rawValue:
            return CGSize(width: collectionView.bounds.width * 0.9,
                          height: 190)
        case K.tags.sortingCollectionViewTag.rawValue:
            if indexPath.row == 1 {
                return CGSize(width: 2,
                              height: 25)
            }
            else {
                return CGSize(width: 75 + indexPath.row * 10,
                              height: 30)
            }
        default:
            print("Unknown collection view")
            return CGSize.zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case K.tags.sortingCollectionViewTag.rawValue:
            return UIEdgeInsets.zero
        case K.tags.listCollectionViewTag.rawValue:
            return UIEdgeInsets(top: 20,
                                left: 0,
                                bottom: 0,
                                right: 0)
        default:
            print("Unknown collection view")
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case K.tags.listCollectionViewTag.rawValue:
            presenter.tappedCell(indexPath: indexPath)
        case K.tags.sortingCollectionViewTag.rawValue:
            presenter.selectedSorting(indexPath: indexPath)
        default:
            print("Unknown collection view")
        }
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
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(modeSelectorTapped))
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(tapGesture)
        
        return stack
    }
    
    private func makeTopTodayLabel() -> UILabel {
        let label = UILabel()
        label.font = K.boldFont
        label.textColor = .black
        label.text = "All Tasks"
        return label
    }
    
    private func makeBottomTodayLabel() -> UILabel {
        let label = UILabel()
        label.font = K.mainFont
        label.textColor = .lightGray
        label.text = "On one page"
        return label
    }
    
    private func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(TaskCollectionViewCell.self,
                                forCellWithReuseIdentifier: TaskCollectionViewCell.reuseId)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.tag = K.tags.listCollectionViewTag.rawValue
        return collectionView
    }
    
    private func makeSortingCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(SortingCollectionViewCell.self,
                                forCellWithReuseIdentifier: SortingCollectionViewCell.reuseId)
        collectionView.register(SeparatorCollectionViewCell.self,
                                forCellWithReuseIdentifier: SeparatorCollectionViewCell.reuseId)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.tag = K.tags.sortingCollectionViewTag.rawValue
        return collectionView
    }
    
    private func makeCreateButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = K.baseBlueColor?.withAlphaComponent(0.35)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 7,
                                              bottom: 0,
                                              right: 0)
        button.setTitle("New Task",
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
