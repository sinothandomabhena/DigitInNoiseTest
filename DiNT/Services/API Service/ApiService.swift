//
//  ApiService.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/28.
//

import Foundation

enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
    case otherError(Error)
}

protocol APIServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data?,
        headers: [String: String]?,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    )
    
    func get<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    func post<T: Decodable>(endpoint: String, body: Data?, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    func put<T: Decodable>(endpoint: String, body: Data?, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    func delete<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

class APIService: APIServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        headers: [String: String]? = ["Content-Type": "application/json"],
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            print("Data: \(String(decoding: data, as: Unicode.UTF8.self))")

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response")
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
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
