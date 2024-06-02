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
    private var networkService : NetworkServiceProtocol
    private var url = "https://api.github.com/users"
    
    
    init(networkService:NetworkServiceProtocol = NetworkService()){
        self.networkService = networkService
    }
    
    func fetchDataByPublisher() {
            networkService.getDataByPublisher(url:url)
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
    
    func fetchDataByCompletion() {
        networkService.getDataByCompletion(url:url) { data, error in
            if let data = data {
                self.users = data
            } else if let error = error {
                // Handle error
                print("Data retrieval using completion failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchDataByAsync() async {
        let users = try? await networkService.getDataByAsync(url: url)
        await MainActor.run{
            self.users = users
        }
    }
    
 
}
