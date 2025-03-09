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
    case invalidURL
    case requestFailed
    case decodingFailed
    case custom(statusCode: Int)
    case invalidData
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "The request failed."
        case .decodingFailed:
            return "Failed to decode response."
        case .custom(let statusCode):
            return "Received error with status code \(statusCode)."
        case .invalidData:
            return "invalidData"
        case .unknown:
            return "unknown"
        case .invalidURL:
            return "invalidURL"
        }
    }
}

