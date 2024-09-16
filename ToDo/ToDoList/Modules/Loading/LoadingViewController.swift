//
//  ViewController.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import UIKit
import Lottie

protocol LoadingViewProtocol: UIViewController {
    func stopAnimation(completion: @escaping () -> Void)
    var presenter: LoadingPresenterProtocol! { get set }
}

class LoadingViewController: UIViewController {
    // MARK: - Private Properties
    private let animationView = LottieAnimationView(name: K.loadingAnimationName)
    var presenter: LoadingPresenterProtocol!
    
    // MARK: - Initializer
    init(presenter: LoadingPresenterProtocol? = nil) {
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
        view.backgroundColor = .white
        setupAnimationView()
        animationView.play()
    }
}

extension LoadingViewController {
    private func setUp() {
        
    }
}

// MARK: - LoadingViewProtocol extension
extension LoadingViewController: LoadingViewProtocol {
    func stopAnimation(completion: @escaping () -> Void) {
        <#code#>
    }
    
    func setupAnimationView() {
        animationView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: 350,
                                     height: 300)
        animationView.center = view.center
        animationView.loopMode = .loop
        view.addSubview(animationView)
    }
    
    func startAnimation() {
        
    }
}
