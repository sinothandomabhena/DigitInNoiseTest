//
//  MockTestResultStore.swift
//  DiNTTests
//
//  Created by Sinothando on 2025/01/30.
//

import Foundation

class MockTestResultStore {
    static func saveTestResults(_ results: [TestResultModel]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(results) {
            MockUserDefaults.shared.set(encoded, forKey: "key")
        }
    }

    static func getTestResults() -> [TestResultModel] {
        if let savedData = MockUserDefaults.shared.data(forKey: "key") {
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
}

