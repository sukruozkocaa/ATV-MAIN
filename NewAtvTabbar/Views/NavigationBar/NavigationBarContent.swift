//
//  NavigationBarContent.swift
//  NewAtvTabbar
//
//  Created by Mehmet Can Şimşek on 22.01.2026.
//

import SwiftUI

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
