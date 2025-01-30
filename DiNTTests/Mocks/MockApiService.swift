//
//  MockApiService.swift
//  DiNTTests
//
//  Created by Sinothando on 2025/01/30.
//

import Foundation

class MockAPIService: APIServiceProtocol {
    var mockResponse: Any?
    var mockError: APIError?
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        headers: [String: String]? = ["Content-Type": "application/json"],
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        if let error = mockError {
            completion(.failure(error))
            return
        }
        
        if let response = mockResponse as? T {
            completion(.success(response))
            return
        }
        
        completion(.failure(.otherError(NSError(domain: "", code: 0, userInfo: nil))))
    }

    func get<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint: endpoint, method: .GET, responseType: responseType, completion: completion)
    }

    func post<T: Decodable>(endpoint: String, body: Data?, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint: endpoint, method: .POST, body: body, responseType: responseType, completion: completion)
    }

    func put<T: Decodable>(endpoint: String, body: Data?, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint: endpoint, method: .PUT, body: body, responseType: responseType, completion: completion)
    }

    func delete<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint: endpoint, method: .DELETE, responseType: responseType, completion: completion)
    }
}
