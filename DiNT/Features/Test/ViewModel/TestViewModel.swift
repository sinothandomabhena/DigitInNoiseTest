//
//  TestViewModel.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/28.
//

import Foundation
import AVFoundation

class TestViewModel: ObservableObject {
    @Published var textInput: String = String()
    @Published var roundCounter: Int = 1
    @Published var progressTracker: Float = 0.0
    @Published var roundDificulty: Int = 5
    @Published var totalTime: TimeInterval = 0.0
    @Published var currentTime: TimeInterval = 0.0
    @Published var digitAudioFileName: String?
    @Published var isSubmitButtonDisabled: Bool = false
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorHasOccured: Bool = false
    
    private var triplets: [[Int]] = [[Int()]]
    private var rounds: [RoundModel] = []

    private var noiseAudioPlayer: AVAudioPlayer?
    private var digitAudioPlayer: AVAudioPlayer?
    
    private let testApi: TestAPIProtocol
    
    init(testApi: TestAPIProtocol) {
        self.testApi = TestAPI(apiService: APIService())
        self.triplets = generateTriplets()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    // MARK: Play Noise Audio Player
    func playNoiseAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "noise_\(roundDificulty)", withExtension: "m4a") else { return }
        
        do {
            noiseAudioPlayer?.stop()
            noiseAudioPlayer = try AVAudioPlayer(contentsOf: url)
            
        } catch {
            print("Error Playing Noise Audio")
        }
        
        noiseAudioPlayer?.play()
    }
    
    // MARK: Play Digit Audio Player
    func playDigitAudioPlayer(triplet: [Int], atIndex index: Int = 0) {
        if index >= triplet.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
                isSubmitButtonDisabled = false
                noiseAudioPlayer?.stop()
            })
            return
        }
                                          
        guard let url = Bundle.main.url(forResource: "\(triplet[index])", withExtension: "m4a") else { return }
        
        do {
            digitAudioPlayer?.stop()
            digitAudioPlayer = try AVAudioPlayer(contentsOf: url)
            
        } catch {
            print("Error Playing Digit Audio")
        }
        
        digitAudioPlayer?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [self] in
            playDigitAudioPlayer(triplet: triplet, atIndex: (index + 1))
        })
    }
    
    // MARK: Stop All Audio
    func stopAllAudio() {
        DispatchQueue.main.async { [self] in
            noiseAudioPlayer?.stop()
            digitAudioPlayer?.stop()
        }
    }
    
    // MARK: Begin Round
    func beginRound() {
        if roundCounter <= 10 {
            playNoiseAudioPlayer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [self] in
                playDigitAudioPlayer(triplet: triplets[roundCounter - 1])
            })
        }
    }
    
    // MARK: Evaluate Answer
    func evaluateAnswer() {
        
        if roundCounter <= triplets.count {
            var answer = ""
            var currentDifficult = roundDificulty
            
            for digit in triplets[roundCounter - 1] {
                answer.append("\(digit)")
            }

            if textInput.replacingOccurrences(of: " ", with: "") == answer {
                print("Round \(roundCounter) - Right! ✅, Difficulty \(roundDificulty)")
                if roundDificulty < 10 {
                    roundDificulty += 1
                }
            } else {
                print("Round \(roundCounter) - Wrong! ❌, Difficulty \(roundDificulty)")
                if roundDificulty > 1 {
                    roundDificulty -= 1
                }
            }
            
     
            rounds.append(RoundModel(tripletPlayed: answer, tripletAnswered: textInput.replacingOccurrences(of: " ", with: ""), difficulty: currentDifficult ))
        }
        
        roundCounter += 1
        progressTracker = Float(roundCounter - 1) / 10.0
        textInput = String()
        isSubmitButtonDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            beginRound()
        }
    }
    
    // MARK: Generate Triplets
    func generateTriplets() -> [[Int]] {
        var triplets: [[Int]] = []
        
        func generateRandomArray() -> [Int] {
            var array: [Int] = []
            while array.count < 3 {
                let randomDigit = Int.random(in: 1...9)
                if !array.contains(randomDigit) {
                    array.append(randomDigit)
                }
            }
            return array
        }

        func isValidArray(newArray: [Int], previousArray: [Int]) -> Bool {
            for (index, value) in newArray.enumerated() {
                if previousArray.count > index && value == previousArray[index] {
                    return false
                }
            }
            return true
        }

        while triplets.count < 10 {
            let newArray = generateRandomArray()
            
            if triplets.isEmpty || isValidArray(newArray: newArray, previousArray: triplets.last!) {
                triplets.append(newArray)
            }
        }
        print("Triplets: \(triplets)")
        return triplets
    }
    
    // MARK: Get Test Score
    func getTestScore() -> Int {
        var score = 0
        for round in rounds {
            if round.tripletAnswered == round.tripletPlayed {
                score += round.difficulty
            }
        }
        return score
    }
    
    // MARK: Save Test Results
    func saveTestResults() {
        let testResults = TestResultModel(score: getTestScore(), rounds: rounds)
        progressTracker = 1.0
        isLoading = true
        isSubmitButtonDisabled = true
        testApi.saveTestResults(results: testResults) { [self] result in
            if result != nil {
                showAlert = true
            } else {
                displayError()
            }
            DispatchQueue.main.async { [self] in
                isLoading = false
                isSubmitButtonDisabled = false
            }
        }
        
        TestResultStore.appendTestResult(testResults)
    }
     
    // MARK: Display Error
    func displayError() {
        DispatchQueue.main.async { [self] in
            errorHasOccured = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            errorHasOccured = false
        }
    }
}
