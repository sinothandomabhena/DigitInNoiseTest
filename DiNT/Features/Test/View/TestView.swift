//
//  TestView.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/28.
//

import SwiftUI

struct TestView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: TestViewModel = TestViewModel(testApi: TestAPI(apiService: APIService()))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressView(value: viewModel.progressTracker)
            TextField("Enter the digits you hear", text: $viewModel.textInput)
                .multilineTextAlignment(.center)
                .padding(10)
                .keyboardType(.numberPad)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.black, lineWidth: 2)
                )
                
            Button {
                if !viewModel.isSubmitButtonDisabled {
                    if viewModel.roundCounter == 10 {
                        viewModel.saveTestResults()
                    } else {
                        viewModel.evaluateAnswer()
                    }
                    
                }
            } label: {
                HStack(spacing: 5) {
                    Text(viewModel.isSubmitButtonDisabled ? viewModel.isLoading ? "Uploading..." : "Listen carefully" : "Submit")
                        .font(.system(size: 20, weight: .medium))
                    if(viewModel.isSubmitButtonDisabled) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(viewModel.isSubmitButtonDisabled ? .gray : .black)
                .cornerRadius(6)
            }
            
            if viewModel.errorHasOccured {
                Text("Failed to upload results. Please try again later.")
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .navigationTitle("Digit in Noise Test")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                        Text("Exit Test")
                    }
                }
            }
        }
        .tint(.black)
        .padding(20)
        .onAppear {
            viewModel.isSubmitButtonDisabled = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
                viewModel.beginRound()
            })
        }
        .alert("Results", isPresented: $viewModel.showAlert) {
            Button {
                viewModel.stopAllAudio()
                dismiss()
            } label: {
                Text("Close Test")
            }
        } message: {
            Text("Your score is: \(viewModel.getTestScore())")
        }

    }
}

#Preview {
    NavigationView {
        TestView()
    }
}
