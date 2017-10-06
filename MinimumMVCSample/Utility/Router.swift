//
//  Router.swift
//  MinimumMVCSample
//
//  Created by maekawakazuma on 2017/10/05.
//  Copyright © 2017 maekawakazuma. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case createTodo(parameters: Parameters)
    case readTodos()
    case updateTodo(id: Int, parameters: Parameters)
    case destroyTodo(id: Int)
    
    static let baseURLString = "https://todo-pad.herokuapp.com"
    
    var method: HTTPMethod {
        switch self {
        case .createTodo:
            return .post
        case .readTodos:
            return .get
        case .updateTodo:
            return .put
        case .destroyTodo:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createTodo:
            return "/todos"
        case .readTodos:
            return "/todos"
        case .updateTodo(let id, _):
            return "/users/\(id)"
        case .destroyTodo(let id):
            return "/users/\(id)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createTodo(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateTodo(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
