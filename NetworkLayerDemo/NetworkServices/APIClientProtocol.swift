//
//  APIClient.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 07/03/2025.
//

import Foundation
import Combine

typealias Handler<T> = (Result<T, APIError>) -> Void

protocol APIClientProtocol {
    associatedtype EndpointType : APIEndpoint
    func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<T, APIError>
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> T?
    func request<T: Codable>(_ endpoint: EndpointType, completion: @escaping Handler<T>)
}

class URLSessionAPIClient<EndpointType : APIEndpoint>: APIClientProtocol {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    //MARK: - publisher
    func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<T, APIError> {
        guard let request = try? endpoint.asURLRequest() else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                try self.validateResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: JSONDecoder ())
            .mapError({ error -> APIError in
                self.mapError(error)
            })
            .eraseToAnyPublisher()
    }
    
    //MARK: - Async
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> T?{
        guard let request = try? endpoint.asURLRequest() else {
            throw APIError.invalidURL
        }
        
        let (data, response) =  try await URLSession.shared.data(for: request)
        let validData = try validateResponse(data: data, response: response)
        return try decoder.decode(T.self, from: validData)
    
    }
    
    //MARK: - Combine
    func request<T: Codable>(_ endpoint: EndpointType, completion: @escaping Handler<T>) {
        guard let request = try? endpoint.asURLRequest() else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result: Result<T, APIError> = self.handleResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        .resume()
    }
    
   
}

extension URLSessionAPIClient {
    // MARK: - Shared Validation
        private func validateResponse(data: Data?, response: URLResponse?) throws -> Data {
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.custom(statusCode: httpResponse.statusCode)
            }
            
            guard let data = data, !data.isEmpty else {
                throw APIError.invalidData
            }
            
            return data
        }
    
    // MARK: - Error Handling
        private func mapError(_ error: Error) -> APIError {
            switch error {
            case let apiError as APIError:
                return apiError
            case is DecodingError:
                return .decodingFailed
            case let urlError as URLError:
                return urlError.code == .notConnectedToInternet ? .requestFailed : .unknown
            default:
                return .unknown
            }
        }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, APIError> {
        do {
            if let error = error {
                throw error
            }
            
            let validData = try validateResponse(data: data, response: response)
            let decoded = try decoder.decode(T.self, from: validData)
            return .success(decoded)
        } catch {
            return .failure(mapError(error))
        }
    }
}

