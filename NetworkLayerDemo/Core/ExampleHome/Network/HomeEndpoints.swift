//
//  HomeEndpoints.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 07/03/2025.
//

import Foundation

enum HomeEndpoints: APIEndpoint {

    case getUsers
    
    
   
    
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
    
    var parameters: [String : Any]?{
        switch self {
        case .getUsers:
            return nil
        }
    }
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.empty
        }
    }
    
    var mockFile: String? {
        switch self {
        case .getUsers:
            return "_getEventsMockResponse"
        }
    }
}


