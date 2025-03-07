//
//  APIModels.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 07/03/2025.
//

import Foundation

// MARK: - APIResponse
//struct APIResponse<T: Codable>: Codable {
//    let status: String
//    let data: T?
//    
//    init(status: String, data: T?) {
//        self.status = status
//        self.data = data
//    }
//}
//        
//extension APIResponse {
//    var success: Bool {
//        status == "success"
//    }
//}

// MARK: - APIErorr
enum APIError: Error, Equatable {
    case requestFailed
    case decodingFailed
    case customError(statusCode: Int)
    case invalidURL
}
