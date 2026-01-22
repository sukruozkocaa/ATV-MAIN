//
//  NavigationBarView.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 20.01.2026.
//

import Foundation
import SwiftUI

// MARK: - NavigationBarView
struct NavigationBarView: View {
    @Binding var selectedTab: Int
    @Binding var isCollapsed: Bool
    @Binding var isGradient: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            // Gradient background blur
            if isGradient {
                backgroundBlurView
            }
            
            // Content
            VStack(spacing: .zero) {
                Spacer().frame(height: 60.0)
                NavigationBarContent(isGradient: $isGradient)
                    .scaleEffect(isCollapsed ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.25), value: isCollapsed)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Background Blur
    @ViewBuilder
    private var backgroundBlurView: some View {
        if #available(iOS 26.0, *) {
            Color.clear
                .frame(height: 130.0)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: .zero))
                .ignoresSafeArea()
        } else {
            BlurView(style: .systemMaterialDark)
                .frame(height: 130.0)
                .ignoresSafeArea()
        }
    }
}
