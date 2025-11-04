//
//  File.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 05/03/2025.
//

import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeader { get }
   // var body: Data? { get }
    var parameters: [String: Any]? { get }
    var mockFile: String? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum HTTPHeader {
    case custom([String: String])
    case `default`
    case `empty`

    var values: [String: String] {
        switch self {
        case .custom(let headers):
            return HTTPHeader.defaultValues.merging(headers) { (_, new) in new }
        case .default:
            return HTTPHeader.defaultValues
        case .empty:
            return [:]

        }
    }

    private static var defaultValues: [String: String] {
        return [
            "Content-Type": "application/json",
            "deviceType" :"IOS",
            "deviceVersion" :""
            
        ]
    }
}

extension APIEndpoint {
    var baseURL: String { 
            return "https://api.github.com"
        }
    
    func asURLRequest() throws -> URLRequest { // 4
        
//        guard let url = URL(string: baseURL.appending(path)) else {
//            throw APIError.requestFailed
//        }
        
        guard let baseURL = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = path
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url) // 6
        urlRequest.httpMethod = method.rawValue
        self.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
//        if let body = body {
//            do {
//                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
//            } catch {
//                throw APIError.requestFailed
//            }
//        }
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw APIError.requestFailed
            }
        }
        
        return urlRequest
    }
}
