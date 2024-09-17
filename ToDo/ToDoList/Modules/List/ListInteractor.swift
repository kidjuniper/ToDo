//
//  ListInteractor.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation

protocol ListInteractorProtocol {

    var presenter: ListPresenterProtocol? { get set }
}

final class ListInteractor: ListInteractorProtocol {
    weak var presenter: ListPresenterProtocol?
    
    init(presenter: ListPresenterProtocol? = nil) {
        self.presenter = presenter
    }
}
