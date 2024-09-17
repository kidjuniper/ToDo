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
        view.backgroundColor = .lightGray
    }
    
    private func setUpLayout() {
        view.addSubviews(todayStack,
                         collectionView)
        
        todayStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
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
    func reloadData() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.9,
                      height: 170)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
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
        label.textColor = .white
        label.text = "Wednesday, 11"
        return label
    }
    
    private func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(TaskCollectionViewCell.self,
                                forCellWithReuseIdentifier: TaskCollectionViewCell.reuseId)
        collectionView.backgroundColor = .clear
        flowLayout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }
}
