//
//  HomeEndpoints.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 07/03/2025.
//

import Foundation

enum HomeEndpoints: APIEndpoint {
    case getUsers
    
    
    var headers: [String : String]?{
        switch self {
        case .getUsers:
            return nil
        }
    }
    
    var body: Data?{
        switch self {
        case .getUsers:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var mockFile: String? {
        switch self {
        case .getUsers:
            return "_getEventsMockResponse"
        }
    }
}


