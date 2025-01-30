//
//  ResultView.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/29.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ResultViewModel = ResultViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.results) { result in
                NavigationLink("Score: \(result.score)") {
                    ResultDetailsView(result: result)
                }
            }
            .listStyle(InsetGroupedListStyle())

        }
        .navigationTitle("Result History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.sortResultsInDescendingOrder()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    TestResultStore.removeTestResults()
                    viewModel.results = []
                } label: {
                    HStack(spacing: 0) {
                        Text("Clear")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .tint(.black)
    }
}

#Preview {
    ResultView()
}
