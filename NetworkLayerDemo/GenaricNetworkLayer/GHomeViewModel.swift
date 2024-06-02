//
//  GHomeViewModel.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 02/06/2024.
//

import Foundation
import SwiftUI
import Combine

class GHomeViewModel:ObservableObject{

    @Published var users : [UserModel]?
    private var  cancellable = Set<AnyCancellable>()
    private var networkService : GNetworkServiceProtocol
    private var url = "https://api.github.com/users"
    
    
    init(networkService:GNetworkServiceProtocol = GNetworkService()){
        self.networkService = networkService
    }
    
    
    func fetchDataByPublisher() {
        networkService.getDataByPublisher(modelType: UserModel.self,url:url)
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
        networkService.getDataByCompletion(modelType: UserModel.self,url:url) { data, error in
            if let data = data {
                self.users = data
            } else if let error = error {
                // Handle error
                print("Data retrieval using completion failed with error: \(error.localizedDescription)")
            }
        }
    }
  
   func fetchDataByAsync() async{
       let users = try? await networkService.getDataByAsync(modelType: UserModel.self, url: url)
       await MainActor.run{
           self.users = users
       }
    }
    
   
        
}

