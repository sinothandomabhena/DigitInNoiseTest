//
//  HomeView.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/28.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("👂")
                    .font(.system(size: 40))
                    .padding(.bottom, 10)
                Text("Digit in Noise Test")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.bottom, 25)
                
                NavigationLink(destination: TestView()) {
                    Text("Start Test")
                        .font(.system(size: 20, weight: .medium))
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.black)
                        .cornerRadius(6)
                }
                
                if viewModel.hasResultHistory {
                    NavigationLink(destination: ResultView()) {
                        Text("View Result History")
                            .font(.system(size: 20, weight: .medium))
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.black, lineWidth: 2)
                            )
                    }
                }
            }
            .padding(20)
            .toolbar(.hidden)
            .onAppear {
                viewModel.checkIfHasResultHistory()
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
