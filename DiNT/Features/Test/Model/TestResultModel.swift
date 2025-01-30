//
//  TestResultModel.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/28.
//

import Foundation

struct TestResultModel: Codable, Identifiable {
    var id = UUID()
    var score: Int
    var rounds: [RoundModel]
    
    init(score: Int, rounds: [RoundModel]) {
        self.score = score
        self.rounds = rounds
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(score, forKey: .score)
        try container.encode(rounds, forKey: .rounds)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        score = try container.decode(Int.self, forKey: .score)
        rounds = try container.decode([RoundModel].self, forKey: .rounds)
    }
    
    enum CodingKeys: String, CodingKey {
        case score, rounds
    }
}


struct RoundModel: Codable, Identifiable {
    var id = UUID()
    var tripletPlayed: String
    var tripletAnswered: String
    var difficulty: Int
    
    init(tripletPlayed: String, tripletAnswered: String, difficulty: Int) {
        self.tripletPlayed = tripletPlayed
        self.tripletAnswered = tripletAnswered
        self.difficulty = difficulty
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tripletPlayed, forKey: .tripletPlayed)
        try container.encode(tripletAnswered, forKey: .tripletAnswered)
        try container.encode(difficulty, forKey: .difficulty)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tripletPlayed = try container.decode(String.self, forKey: .tripletPlayed)
        tripletAnswered = try container.decode(String.self, forKey: .tripletAnswered)
        difficulty = try container.decode(Int.self, forKey: .difficulty)
    }
    
    enum CodingKeys: String, CodingKey {
        case tripletPlayed, tripletAnswered, difficulty
    }
}


struct EmptyResponse: Codable {}
