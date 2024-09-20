//
//  TextView.swift
//  ToDo
//
//  Created by Nikita Stepanov on 20.09.2024.
//

import Foundation
import UIKit

class TextView: UITextView {

    private let padding = UIEdgeInsets(top: 10,
                                        left: 16,
                                        bottom: 10,
                                        right: 16)

    override var textContainerInset: UIEdgeInsets {
        get {
            return padding
        }
        set {
            super.textContainerInset = newValue
        }
    }

    override var contentInset: UIEdgeInsets {
        get {
            return padding
        }
        set {
            super.contentInset = newValue
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textContainer.lineFragmentPadding = 0
    }
}
