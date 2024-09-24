//
//  LoadingInteractorSpy.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import Foundation
import UIKit

@testable import ToDo

protocol LoadingInteractorSpyProtocol: LoadingInteractorProtocol {
    var requestDataCalled: Bool { get }
}

final class LoadingInteractorSpy {
    var presenter: LoadingPresenterProtocol!
    
    private(set) var requestDataCalled = false
}

extension LoadingInteractorSpy: LoadingInteractorSpyProtocol {
    func requestData() {
        requestDataCalled = true
    }
}
