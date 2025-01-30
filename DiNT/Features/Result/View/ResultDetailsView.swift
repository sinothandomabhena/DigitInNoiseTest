//
//  ResultDetailsView.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/29.
//

import SwiftUI

struct ResultDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    var result: TestResultModel

    var body: some View {
        VStack {
            List(result.rounds) { round in
                Text("Played: \(round.tripletPlayed) - Answered: \(round.tripletAnswered) \(round.tripletPlayed == round.tripletAnswered ? "✅" : "❌")")
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarBackButtonHidden(true)
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
        }
        .tint(.black)
    }
}
