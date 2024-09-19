//
//  AddingPresenter.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation
import UIKit

protocol AddingPresenterProtocol: AnyObject,
                                  UITextFieldDelegate {
    func viewDidLoad()
    func updateCurrentTitle(withTitle title: String)
    func updateCurrentComment(withText text: String)
    func updateCurrentDateInterval(startDate: Date,
                                   endDate: Date)
    func saveButtonTapped()
    
    var view: AddingViewProtocol! { get set }
    var interactor: AddingInteractorProtocol! { get set }
    var router: AddingRouterProtocol! { get set }
}

final class AddingPresenter: NSObject,
                             AddingPresenterProtocol {
    func saveButtonTapped() {
        interactor.save(task: data)
        router.dismiss()
    }
    
    var view: AddingViewProtocol!
    var interactor: AddingInteractorProtocol!
    var router: AddingRouterProtocol!
    
    // MARK: - Private Properties
    private var data: TaskModel
    private let mode: AddingMode
    
    init(view: AddingViewProtocol? = nil,
         interactor: AddingInteractorProtocol? = nil,
         router: AddingRouterProtocol? = nil,
         data: TaskModel,
         mode: AddingMode) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.data = data
        self.mode = mode
    }
    
    func viewDidLoad() {
        view.setUpWithData(data: data,
                           mode: mode)
    }
    
    func updateCurrentTitle(withTitle title: String) {
        data.todo = title
    }
    
    func updateCurrentComment(withText text: String) {
        data.comment = text
    }
    
    func updateCurrentDateInterval(startDate: Date,
                                        endDate: Date) {
        data.startDate = startDate
        data.endDate = endDate
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let maxLength = 50
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range,
                                                          with: string)
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            view.makeCommentTextFieldFirstResponder()
        case 2:
            view.makeDateTextFieldFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
