//
//  HomeViewModel.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 02/06/2024.
//

import Foundation
import SwiftUI
import Combine

//MARK: - VM

class HomeViewModel:ObservableObject{
    
    @Published var users : [UserModel]?
    private var  cancellable = Set<AnyCancellable>()
    private var apiClient : HomeAPIClientProtocol
    
    
    init(apiClient:HomeAPIClientProtocol = HomeAPIClient()){
        self.apiClient = apiClient
    }
    
    func fetchDataByPublisher() {
        apiClient.getUsers()
           .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Data retrieval finished")
                case .failure(let error):
                    print("Data retrieval failed with error: \(error.localizedDescription)")
                }
            } receiveValue: { data in
                self.users = data
            }
            .store(in: &cancellable)
        }
    
    func fetchDataByAsync() async {
        let users = try? await apiClient.getUsers()
        await MainActor.run{
            self.users = users
        }
    }
    
    func fetchDataByCompletion() {
        apiClient.getUser { Result in
            switch Result {
            case .success(let data):
                self.users = data
            case .failure(let error):
                print("Data retrieval using completion failed with error: \(error.localizedDescription)")
            }
        }
    }
    
  
    
 
}
