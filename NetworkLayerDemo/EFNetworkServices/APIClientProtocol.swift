//
//  APIClient.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 07/03/2025.
//

import Foundation
import Combine

typealias Handler<T> = ([T]?, Error?) -> Void

protocol APIClientProtocol {
    associatedtype EndpointType : APIEndpoint
    func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<T, APIError>
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> [T]?
    func request<T: Codable>(_ endpoint: EndpointType, completion: @escaping Handler<T>)
}

class URLSessionAPIClient<EndpointType : APIEndpoint>: APIClientProtocol {
    
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    //MARK: - publisher
    func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<T, APIError> {
        let request = try! endpoint.asURLRequest()
        return session.dataTaskPublisher (for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.requestFailed
                }
                guard (200 ... 299).contains(httpResponse.statusCode) else {
                    throw APIError.customError (statusCode: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder ())
            .mapError({ error -> APIError in
                guard let error = error as? APIError else {
                    return APIError.decodingFailed
                }
                return error
            })
            .eraseToAnyPublisher()
    }
    
    //MARK: - Async
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> [T]?{
        let request = try! endpoint.asURLRequest()
        
        let (data, response) =  try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed
        }
        guard (200 ... 299).contains(httpResponse.statusCode) else {
            throw APIError.customError (statusCode: httpResponse.statusCode)
        }
        let json = try JSONDecoder().decode([T].self, from: data)
        return json
    
    }
    
    //MARK: - Combine
    func request<T: Codable>(_ endpoint: EndpointType, completion: @escaping Handler<T>) {
        let request = try! endpoint.asURLRequest()
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                do{
                    let json = try JSONDecoder().decode([T].self, from: data)
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
                    completion(nil, APIError.requestFailed)
                    
                }
            }
        }
        .resume()
    }
}


protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {}
