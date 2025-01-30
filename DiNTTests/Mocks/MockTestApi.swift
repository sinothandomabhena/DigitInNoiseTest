//
//  MockTestApi.swift
//  DiNTTests
//
//  Created by Sinothando on 2025/01/30.
//

import Foundation

class MockTestAPI: TestAPIProtocol {
    let apiService: APIServiceProtocol
    let endpoint: String = ""
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func saveTestResults(results: TestResultModel, completion: @escaping (Bool?) -> ()) {
    
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try? encoder.encode(results)
        
        print("Request: \(String(decoding: body!, as: Unicode.UTF8.self))")
        
        apiService.post(endpoint: endpoint, body: body, responseType: EmptyResponse.self) { result in
            switch result {
            case .success(let success):
                completion(true)
            case .failure(let failure):
                completion(nil)
            }
        }
    }
}
