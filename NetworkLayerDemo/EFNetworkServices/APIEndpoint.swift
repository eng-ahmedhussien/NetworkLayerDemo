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
    var headers: [String: String]? { get }
    var body: Data? { get }
    var mockFile: String? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension APIEndpoint {
    var baseURL: String { 
            return "https://api.github.com"
        }
    
    func asURLRequest() throws -> URLRequest { // 4
        
        guard let url = URL(string: baseURL.appending(path)) else {
            throw APIError.requestFailed
        }
        
        var urlRequest = URLRequest(url: url) // 6
        urlRequest.httpMethod = method.rawValue
        self.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw APIError.requestFailed
            }
        }
        return urlRequest
    }
}
