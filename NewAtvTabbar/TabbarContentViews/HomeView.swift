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
    
    @State private var selectedTab = 0
    @State private var isCollapsed = false
    @State private var isGradient = false
    @State private var scrollOffset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var accumulatedScroll: CGFloat = 0
    let threshold: CGFloat = 20

    var body: some View {
        ZStack(alignment: .top) {
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
                    .padding(.bottom)
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY
                                )
                        }
                    )
                }
                .coordinateSpace(name: "scroll")
                .refreshable {
                    viewModel.fetchData()
                }
                .ignoresSafeArea()
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    let offset = max(-value, 0)
                    scrollOffset = offset
                    
                    let isScrollingDown = offset > lastOffset
                    let isScrollingUp   = offset < lastOffset
                    
                    if isScrollingDown {
                        accumulatedScroll += offset - lastOffset
                    } else if isScrollingUp {
                        accumulatedScroll -= lastOffset - offset
                    }
                    
                    if accumulatedScroll > threshold {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isCollapsed = true
                        }
                        accumulatedScroll = 0
                    }
                    
                    if accumulatedScroll < -threshold {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isCollapsed = false
                        }
                        accumulatedScroll = 0
                    }
                    
                    if offset >= 50.0 {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isGradient = true
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isGradient = false
                        }
                    }
                    
                    lastOffset = offset
                }
                .ignoresSafeArea(.all)
            }
            
            NavigationBarView(selectedTab: $selectedTab, isCollapsed: $isCollapsed, isGradient: $isGradient)
                .frame(height: 150.0)
                .frame(maxWidth: .infinity, alignment: .top)
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
