//
//  HomeAPIClient.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 07/03/2025.
//

import Foundation
import Combine

protocol HomeAPIClientProtocol {
    func getUsers() -> AnyPublisher<[UserModel], APIError>
    func getUsers() async throws -> [UserModel]?
    func getUser(completion: @escaping Handler<UserModel>)
}

class HomeAPIClient: HomeAPIClientProtocol {
    let urlSessionAPIClient = URLSessionAPIClient<HomeEndpoints>()
    func getUsers() -> AnyPublisher<[UserModel], APIError> {
        return urlSessionAPIClient.request(.getUsers)
    }
    
    func getUsers() async throws -> [UserModel]?{
        return try await urlSessionAPIClient.request(.getUsers)
    }
    
    func getUser(completion: @escaping Handler<UserModel>) {
        urlSessionAPIClient.request(.getUsers, completion: completion)
    }
}
