//
//  DummyjsonAPIManager.swift
//  ToDoList
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation
import Alamofire

protocol DummyjsonAPIManagerProtocol {
    func requestData(completion: @escaping (Result<Tasks,
                                            DummyjsonAPIError>) -> Void)
}

final class DummyjsonAPIManager: DummyjsonAPIManagerProtocol {
    let getAllRequest = DummyRoute.getAll
    func requestData(completion:@escaping (Result<Tasks,
                                           DummyjsonAPIError>) -> Void) {
        do {
            let urlRequest = try getAllRequest.asURLRequest()
            
            AF.request(urlRequest).responseDecodable(of: Tasks.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(.invalidJSON))
                }
            }
        } catch {
            completion(.failure(.failedRequest))
        }
    }
}

enum DummyjsonAPIError: Error {
    case failedRequest
    case invalidJSON
}
