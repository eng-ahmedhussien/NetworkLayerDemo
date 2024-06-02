//
//  NetworkService.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 02/06/2024.
//

import Foundation
import SwiftUI
import Combine

//getData from url by 3 methods
///1- getDataByFuture
///2- getDataByPublisher
///3- getDataByComplition
///4-using async await
//using dataTaskPublisher && dataTask

//MARK: - NetworkService
typealias Handler = ([UserModel]?, Error?) -> Void

protocol NetworkServiceProtocol {
    func getDataByPublisher(url:String) -> AnyPublisher<[UserModel],Error>
    func getDataByCompletion(url:String, completion: @escaping Handler)
    func getDataByAsync(url:String)async throws -> [UserModel]?
   
}

class NetworkService:NetworkServiceProtocol {
    private var cancellable  = Set<AnyCancellable>()
    
    func getDataByPublisher(url:String) -> AnyPublisher<[UserModel],Error> {
        
        guard let url = URL(string: url) else {
            return Fail(error: DataError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                return output.data
            }
            .decode(type:[UserModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getDataByCompletion(url:String, completion: @escaping Handler) {
        
        guard let url = URL(string: url)else {
            completion(nil, DataError.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data{
                do{
                    let json = try JSONDecoder().decode([UserModel].self, from: data)
                    DispatchQueue.main.async{
                        completion(json, nil)
                        print("success to get all Data")
                    }
                }catch let decodingError{
                    DispatchQueue.main.async{
                        print("error when get All data")
                        completion(nil, decodingError)
                    }
                }
            }
            if let error = error {
                DispatchQueue.main.async {
                    print("Error in network request: \(error.localizedDescription)")
                    completion(nil, DataError.networkError)
                }
            }
        }.resume()
    }
    
    func getDataByAsync(url:String) async throws ->  [UserModel]?{
        guard let url = URL(string:url) else {
            throw URLError(.badURL)
        }
        
        let (data, response) =  try await URLSession.shared.data(from: url)
        let json = try JSONDecoder().decode([UserModel].self, from: data)
        return json
    }
    
    
}
