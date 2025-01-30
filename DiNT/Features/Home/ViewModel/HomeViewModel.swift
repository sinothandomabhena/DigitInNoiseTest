//
//  HomeViewModel.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/28.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var hasResultHistory: Bool = false
    
    func checkIfHasResultHistory() {
        hasResultHistory = TestResultStore.getTestResults().isEmpty ? false : true
    }
}
