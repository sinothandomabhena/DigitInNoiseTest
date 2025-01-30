//
//  TestResultStore.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/30.
//

import Foundation

struct UserDefaultsKeys {
    static let testResults = "testResults"
}

class TestResultStore {
    static func saveTestResults(_ results: [TestResultModel]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(results) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.testResults)
        }
    }

    static func getTestResults() -> [TestResultModel] {
        if let savedData = UserDefaults.standard.data(forKey: UserDefaultsKeys.testResults) {
            let decoder = JSONDecoder()
            if let decodedResults = try? decoder.decode([TestResultModel].self, from: savedData) {
                return decodedResults
            }
        }
        return []
    }

    static func appendTestResult(_ result: TestResultModel) {
        var currentResults = getTestResults()
        currentResults.append(result)
        saveTestResults(currentResults)
    }
    
    static func removeTestResults() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.testResults)
    }
}
