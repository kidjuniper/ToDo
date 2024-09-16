//
//  LoadingPresenter.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation

protocol LoadingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func dataFetched(data: [Int])
    
    var view: LoadingViewProtocol! { get set }
    var interactor: LoadingInteractorProtocol! { get set }
    var router: LoadingRouterProtocol! { get set }
}

final class LoadingPresenter: LoadingPresenterProtocol {
    var view: LoadingViewProtocol!
    var interactor: LoadingInteractorProtocol!
    var router: LoadingRouterProtocol!
    
    init(view: LoadingViewProtocol? = nil,
         interactor: LoadingInteractorProtocol? = nil,
         router: LoadingRouterProtocol? = nil) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        let isFirst = interactor.checkIfItFirstLaunch()
        if isFirst {
            interactor.requestInitialData()
        }
        else {
            interactor.requestSavedData()
        }
    }
    
    func dataFetched(data: [Int]) {
        router.presentMainScreen(withData: data)
    }
}
