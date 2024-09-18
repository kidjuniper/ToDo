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
    var presenter: LoadingPresenterProtocol!
    
    // MARK: - Private Properties
    private let animationView = LottieAnimationView(name: K.loadingAnimationName)
    
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
        setUp()
        presenter.viewDidLoad()
    }
}

// MARK: - SetUp
extension LoadingViewController {
    private func setUp() {
        setUpBackground()
        setUpAnimation()
    }
    
    private func setUpAnimation() {
        animationView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: 350,
                                     height: 300)
        animationView.center = view.center
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
    }
    
    private func setUpBackground() {
        view.backgroundColor = .white
    }
}

// MARK: - LoadingViewProtocol extension
extension LoadingViewController: LoadingViewProtocol {
    func stopAnimation(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.75,
                           animations: {
                self.animationView.layer.opacity = 0
            }) { _ in
                completion()
            }
        }
    }
}
