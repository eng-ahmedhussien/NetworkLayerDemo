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
    func getUser(completion: @escaping Handler<[UserModel]>)
}

class HomeAPIClient: URLSessionAPIClient<HomeEndpoints>, HomeAPIClientProtocol {
    func getUsers() -> AnyPublisher<[UserModel], APIError> {
        request(.getUsers)
    }
    
    func getUsers() async throws -> [UserModel]?{
        try await request(.getUsers)
    }
    
    func getUser(completion: @escaping Handler<[UserModel]>) {
        request(.getUsers, completion: completion)
    }
}
