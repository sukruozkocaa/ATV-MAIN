//
//  TabbarOptions2.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 19.01.2026.
//

import Foundation
import SwiftUI

enum TabbarOptions2Item: String, CaseIterable {
    case home = "Ana Sayfa"
    case explore = "Keşfet"
    case live = "Canlı Yayın"
    case stream = "Yayın Akışı"
    case all = "Tümü"
    
    var icon: String {
        switch self {
        case .home: return "atv_logo_v2"
        case .explore: return "discovery_tab"
        case .live: return "live_tab"
        case .stream: return "discovery_tab"
        case .all: return "search_tab"
        }
    }
}

struct TabbarOptions2: View {
    @State private var selectedTab: TabbarOptions2Item = .home
    
    init() {
        // Native tab bar'ı gizle
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Native TabView
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(TabbarOptions2Item.home)
                
                ExploreView()
                    .tag(TabbarOptions2Item.explore)
                
                LiveView()
                    .tag(TabbarOptions2Item.live)
                
                StreamView()
                    .tag(TabbarOptions2Item.stream)
                
                AllView()
                    .tag(TabbarOptions2Item.all)
            }
            .padding(.bottom, 50)
            
            // Özel TabBar Overlay
            TabbarOptions2Overlay(selectedTab: $selectedTab)
                .background(
                    Color("bg_color")
                        .ignoresSafeArea(edges: .bottom)
                )
                .padding(.bottom, -16)

        }
        .background(Color("bg_color").ignoresSafeArea())
        .ignoresSafeArea(.keyboard)
    }
}

struct TabbarOptions2Overlay: View {
    @Binding var selectedTab: TabbarOptions2Item
    
    private var tabWidth: CGFloat {
        let totalSpacing: CGFloat = 5.0 * 4
        let horizontalPadding: CGFloat = 80.0
        let screenWidth = UIScreen.main.bounds.width
        
        return (screenWidth - totalSpacing - horizontalPadding) / 5
    }
    
    var body: some View {
        ZStack {
            // GRADIENT ARKA PLAN
            HStack(spacing: 8.0) {
                ForEach(TabbarOptions2Item.allCases, id: \.self) { tab in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color("tab_gradient_color").opacity(1.0),
                                    Color("tab_gradient_color").opacity(1.0),
                                    Color("tab_gradient_color").opacity(0.8),
                                    Color("tab_gradient_color").opacity(0.6)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80.0, height: 80.0)
                        .blur(radius: 22)
                        .opacity(selectedTab == tab ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedTab)
                        .frame(width: tabWidth)
                }
            }
            .frame(height: 50.0)
            .offset(y: 45.0)
            
            // TAB İTEMLARI
            HStack(spacing: 8.0) {
                ForEach(TabbarOptions2Item.allCases, id: \.self) { tab in
                    TabbarOptions2ItemView(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation {
                            selectedTab = tab
                        }
                    }
                    .frame(width: tabWidth)
                }
            }
        }
        .frame(height: 60.0)
        .background(Color("bg_color"))
    }
}

struct TabbarOptions2ItemView: View {
    let tab: TabbarOptions2Item
    let isSelected: Bool
    let action: () -> Void
    
    var selectedIconColor: Color {
        if tab == .home {
            return .white
        } else {
            return Color(red: 0.93, green: 0.43, blue: 0.18)
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                VStack(alignment: .center, spacing: 7.5) {
                    ZStack(alignment: .center) {
                        Image(tab.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 27.0)
                            .foregroundColor(isSelected ? .white : Color("text_color"))
                        
                        // Canlı yayın noktası
                        if tab == .live {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -6)
                        }
                    }
                                    
                    Text(tab.rawValue)
                        .font(.system(size: 10.0))
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }
            }
            .foregroundColor(isSelected ? .white: Color("text_color"))
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

