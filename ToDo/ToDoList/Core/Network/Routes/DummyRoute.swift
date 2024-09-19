//
//  DummyRoute.swift
//  ToDo
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation
import Alamofire

enum DummyRoute: ExtendedRequest {
    case getAll
    case getOne
    
    var path: String {
        switch self {
        case .getAll:
            return "/todos"
        case .getOne:
            return "/todos/1"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAll:
            return .get
        case .getOne:
            return .get
        }
    }
}

