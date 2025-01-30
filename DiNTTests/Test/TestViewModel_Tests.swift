//
//  TestViewModel_Tests.swift
//  DiNTTests
//
//  Created by Sinothando on 2025/01/30.
//

import XCTest
@testable import DiNT

class TestViewModel_Tests: XCTestCase {
    var viewModel: TestViewModel!
    
    override func setUp()  {
        super.setUp()
        viewModel = TestViewModel(testApi: MockTestAPI(apiService: MockAPIService()))
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    private func isValidArray(newArray: [Int], previousArray: [Int]) -> Bool {
        for (index, value) in newArray.enumerated() {
            if previousArray.count > index && value == previousArray[index] {
                return false
            }
        }
        return true
    }
    
    func testGenerateTripletsLength() {
        let triplets = viewModel.generateTriplets()
        XCTAssertEqual(triplets.count, 10, "There should be exactly 10 triplets.")
    }
    
    func testTripletUniqueness() {
        let triplets = viewModel.generateTriplets()
        
        for triplet in triplets {
            XCTAssertEqual(Set(triplet).count, 3, "Each triplet should contain unique digits.")
            for digit in triplet {
                XCTAssertTrue(digit >= 1 && digit <= 9, "Each digit in the triplet should be between 1 and 9.")
            }
        }
    }
    
    func testNoExactMatchesBetweenTriplets() {
        let triplets = viewModel.generateTriplets()
        
        for i in 1..<triplets.count {
            let previousTriplet = triplets[i - 1]
            let currentTriplet = triplets[i]
            XCTAssertFalse(previousTriplet == currentTriplet, "The current triplet should not be identical to the previous one.")
        }
    }
    
    func testAllGeneratedTripletsAreValid() {
        let triplets = viewModel.generateTriplets()
        
        for i in 1..<triplets.count {
            let previousTriplet = triplets[i - 1]
            let currentTriplet = triplets[i]
            XCTAssertTrue(isValidArray(newArray: currentTriplet, previousArray: previousTriplet), "Triplets should not match the previous triplet.")
        }
    }
}
