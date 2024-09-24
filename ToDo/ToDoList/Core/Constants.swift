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
    
    // MARK: - Text data
    static let fillDataAlertTitle = "Can't save task"
    static let fillDataAlertMessage = "Please, enter task's name and date interval"
    
    // MARK: - Colors
    static let backgroundColor = UIColor(named: "foregroundGray")
    static let baseBlueColor = UIColor(named: "baseBlue")
    
    // MARK: - Tags
    enum tags: Int {
        case listCollectionViewTag = 70001
        case sortingCollectionViewTag = 70002
        case theMockStorageDataTag = 20001
        case theMockAPIDataTag = 20002
    }
    
    // MARK: - Layout
    
    static let topSpace = UIScreen.main.bounds.height / UIScreen.main.bounds.width > 2 ? 80 : 40
    static let bottomSpace = UIScreen.main.bounds.height / UIScreen.main.bounds.width > 2 ? 60 : 40
    
    // MARK: - Other
    static let sortingModes = ["All",
                               "Separator",
                               "Open",
                               "Closed"]
}
