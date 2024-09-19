// 
//  NetworkRequestParams.swift
//  ToDo
//
//  Created by Nikita Stepanov on 16.09.2024.
//

import Foundation
import Alamofire

public typealias ExtendedRequest = NetworkRequestParams & URLRequestConvertible

public protocol NetworkRequestParams {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
}

extension NetworkRequestParams {
    public var baseUrl: URL {
        return URL(string: "https://dummyjson.com")!
    }
    
    public var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}

extension URLRequestConvertible where Self: NetworkRequestParams {
    public func asURLRequest() throws -> URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        var request = try URLRequest(url: url,
                                     method: method)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 30
        return request
    }
}
