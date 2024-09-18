//
//  Constants.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation
import UIKit

struct K {
    // MARK: - Fonts
    static let mainFont = UIFont(name: "Geeza Pro Bold",
                                 size: 16)
    static let boldFont = UIFont(name: "Geeza Pro Bold",
                                 size: 26)
    static let lightFont = UIFont(name: "Geeza Pro",
                                  size: 14)
    
    // MARK: - Lottie animations names
    static let loadingAnimationName = "loading"
    static let addingModuleAnimationName = "kisa"
    
    // MARK: - Data templates
    static let commentStringTemplate = "Notes or comments have not been added to the task"
    static let titleStringTemplate = "Mystery. We lost the title"
    
    // MARK: - Colors
    static let backgroundColor = UIColor(named: "foregroundGray")
    static let baseBlueColor = UIColor(named: "baseBlue")
}
