//
//  LoadingPresenter.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol LoadingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func dataFetched(data: [TaskModel])
    
    var view: LoadingViewProtocol! { get set }
    var interactor: LoadingInteractorProtocol! { get set }
    var router: LoadingRouterProtocol! { get set }
}

final class LoadingPresenter {
    var view: LoadingViewProtocol!
    var interactor: LoadingInteractorProtocol!
    var router: LoadingRouterProtocol!
    
    // MARK: - Initializer
    init(view: LoadingViewProtocol,
         interactor: LoadingInteractorProtocol? = nil,
         router: LoadingRouterProtocol? = nil) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - LoadingPresenterProtocol extension
extension LoadingPresenter: LoadingPresenterProtocol {
    func viewDidLoad() {
        let isFirst = interactor.checkIfItFirstLaunch()
        if isFirst {
            interactor.requestInitialData()
        }
        else {
            interactor.requestSavedData()
        }
    }
    
    func dataFetched(data: [TaskModel]) {
        self.view.stopAnimation {
            self.router.presentListScreen(withData: data)
        }
    }
}
