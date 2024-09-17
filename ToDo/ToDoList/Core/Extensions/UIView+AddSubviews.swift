//
//  UIView+AddSubviews.swift
//  ToDo
//
//  Created by Nikita Stepanov on 17.09.2024.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
