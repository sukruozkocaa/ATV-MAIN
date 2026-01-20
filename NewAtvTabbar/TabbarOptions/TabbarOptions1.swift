//
//  TabbarOptions1.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 19.01.2026.
//

import Foundation
import SwiftUI

enum TabbarOptions1Item: String, CaseIterable {
    case home = "Ana Sayfa"
    case explore = "Keşfet"
    case live = "Canlı Yayın"
    case stream = "Yayın Akışı"
    case all = "Tümü"
    
    var icon: String {
        switch self {
        case .home: return "atv_logo_v2"
        case .explore: return "safari"
        case .live: return "tv"
        case .stream: return "film"
        case .all: return "magnifyingglass"
        }
    }
}

// MARK: - Main ContentView with System TabView
struct TabbarOptions1: View {
    @State private var selectedTab: TabbarOptions1Item = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(TabbarOptions1Item.home)
                
                ExploreView()
                    .tag(TabbarOptions1Item.explore)
                
                LiveView()
                    .tag(TabbarOptions1Item.live)
                
                StreamView()
                    .tag(TabbarOptions1Item.stream)
                
                AllView()
                    .tag(TabbarOptions1Item.all)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom TabBar overlay
            TabbarOptions1Overlay(selectedTab: $selectedTab)
                .padding(.bottom, .zero)
        }
        .background(Color("bg_color").ignoresSafeArea())
        .ignoresSafeArea()
    }
}

struct TabbarOptions1Overlay: View {
    
    @Binding var selectedTab: TabbarOptions1Item
    
    private var tabWidth: CGFloat {
        let totalSpacing: CGFloat = 12 * 4
        let horizontalPadding: CGFloat = 32
        let screenWidth = UIScreen.main.bounds.width
        
        return (screenWidth - totalSpacing - horizontalPadding) / 5
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(TabbarOptions1Item.allCases, id: \.self) { tab in
                TabbarOptions1TabItemView(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
                .frame(width: tabWidth)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct TabbarOptions1TabItemView: View {
    
    let tab: TabbarOptions1Item
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30.0)
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.4, blue: 0.0),
                                    Color(red: 0.8, green: 0.3, blue: 0.0),
                                    Color(red: 0.4, green: 0.15, blue: 0.0),
                                    Color(red: 0.2, green: 0.1, blue: 0.05),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100.0
                            )
                        )
                        .frame(width: 100.0, height: 60.0)
                        .offset(y: 40)
                        .blur(radius: 30.0)
                        .scaleEffect(isSelected ? 1.0 : 0.3)
                        .opacity(isSelected ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
                    
                    VStack(alignment: .center, spacing: 12.0) {
                        ZStack(alignment: .center) {
                            if tab == .home {
                                Image(tab.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 28.0)
                            } else {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 22, weight: .medium))
                            }
                            
                            // Canlı yayın noktası
                            if tab == .live {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 8, y: -6)
                            }
                        }
                        
                        Text(tab.rawValue)
                            .font(.system(size: 12))
                            .multilineTextAlignment(.center)
                            .fixedSize()
                        
                        Spacer().frame(height: 5.0)
                    }
                }
            }
            .foregroundColor(isSelected ? .white : .gray)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

