//
//  HomeView.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 19.01.2026.
//

import Foundation
import SwiftUI

// MARK: - Tab Content Views
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            // Ana arka plan
            Color(hex: "FF141518").ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Button("Retry") {
                        viewModel.fetchData()
                    }
                    .padding()
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.sections) { section in
                            SectionView(data: section)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    viewModel.fetchData()
                }
                .padding(.top, -16)
                .ignoresSafeArea(.all)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
