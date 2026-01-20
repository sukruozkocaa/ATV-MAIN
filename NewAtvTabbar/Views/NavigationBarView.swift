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

// MARK: - NavigationBarContent
struct NavigationBarContent: View {
    @Binding var isGradient: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Logo
            Image("atv_logo_v2")
                .resizable()
                .scaledToFit()
                .frame(width: 50.0)
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 24) {
                actionButton(icon: "bell")
                actionButton(icon: "person.circle")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Action Button
    @ViewBuilder
    private func actionButton(icon: String) -> some View {
        Button {
            // Action
        } label: {
            Image(systemName: icon)
                .font(.system(size: 22.0))
                .foregroundColor(.white)
        }
        .frame(width: 42, height: 42)
        .background(buttonBackground)
        .clipShape(Circle())
    }
    
    // MARK: - Button Background
    @ViewBuilder
    private var buttonBackground: some View {
        if !isGradient {
            if #available(iOS 26.0, *) {
                Color.clear
                    .glassEffect(.regular.interactive(), in: .circle)
            } else {
                Circle()
                    .fill(.ultraThinMaterial)
            }
        }
    }
}
