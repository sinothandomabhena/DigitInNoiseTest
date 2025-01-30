//
//  ResultViewModel.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/29.
//

import Foundation

class ResultViewModel: ObservableObject {
    @Published var results: [TestResultModel] = []
    
    func sortResultsInDescendingOrder() {
        results = TestResultStore.getTestResults().sorted { $0.score > $1.score }
    }
}
