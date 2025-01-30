//
//  TestAPI.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/28.
//

import Foundation

class TestAPI {
    let apiService: APIService
    let endpoint: String = "https://enoqczf2j2pbadx.m.pipedream.net"
    
    init(apiService: APIService) {
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
