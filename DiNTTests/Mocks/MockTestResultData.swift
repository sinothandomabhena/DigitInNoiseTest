//
//  MockTestResultData.swift
//  DiNTTests
//
//  Created by Sinothando on 2025/01/30.
//

import Foundation

var mockTestResult: [TestResultModel] = [
    TestResultModel(score: 75, rounds: [
        RoundModel(tripletPlayed: "123", tripletAnswered: "123", difficulty: 5),
        RoundModel(tripletPlayed: "456", tripletAnswered: "456", difficulty: 6),
        RoundModel(tripletPlayed: "789", tripletAnswered: "789", difficulty: 7),
        RoundModel(tripletPlayed: "134", tripletAnswered: "134", difficulty: 8),
        RoundModel(tripletPlayed: "567", tripletAnswered: "564", difficulty: 9),
        RoundModel(tripletPlayed: "987", tripletAnswered: "981", difficulty: 8),
        RoundModel(tripletPlayed: "739", tripletAnswered: "739", difficulty: 7),
        RoundModel(tripletPlayed: "184", tripletAnswered: "184", difficulty: 8),
        RoundModel(tripletPlayed: "023", tripletAnswered: "392", difficulty: 9),
        RoundModel(tripletPlayed: "754", tripletAnswered: "643", difficulty: 8),
    ])
]
