//
//  LoadingViewControllerSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol LoadingViewControllerSpyProtocol: LoadingViewProtocol {
    var stopAnimationCalled: Bool { get }
}

final class LoadingViewControllerSpy: UIViewController {
    var presenter: LoadingPresenterProtocol!
    
    private(set) var stopAnimationCalled = false
}

extension LoadingViewControllerSpy: LoadingViewControllerSpyProtocol {
    func stopAnimation(completion: @escaping () -> Void) {
        stopAnimationCalled = true
        completion()
    }
}
