//
//  WidgetTitleView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 20.01.2026.
//

import SwiftUI

struct WidgetTitleView: View {
    let title: String
    let fontSize: CGFloat
    let color: Color
    var redirectUrl: String? = nil
    var onRedirect: (() -> Void)? = nil
    
    var body: some View {
        let components = title.components(separatedBy: "|")
        
        if components.count > 1 {
            HStack(spacing: 8) {
                Text(components[0].trimmingCharacters(in: .whitespaces))
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(Color(hex: "#FF5C00")) // Using a standard orange, can be adjusted
                
                Text("|")
                    .font(.system(size: fontSize, weight: .light))
                    .foregroundColor(color.opacity(0.7))
                
                Text(components[1].trimmingCharacters(in: .whitespaces))
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(color)
            }
            .padding(.bottom, 4)
            
            Spacer()
            
            if let _ = redirectUrl {
                Button {
                    onRedirect?()
                } label: {
                    HStack(spacing: 4) {
                        Text("Tümünü gör")
                            .font(.system(size: 12))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.gray)
                }
                .padding(.bottom, 4)
            }
        } else {
            HStack {
                Text(title)
                    .font(.system(size: fontSize, weight: .bold)) // Keep original bold if standard title
                    .foregroundColor(color)
                    .padding(.bottom, 4)
                
                Spacer()
                
                if let _ = redirectUrl {
                    Button {
                        onRedirect?()
                    } label: {
                        HStack(spacing: 4) {
                            Text("Tümünü gör")
                                .font(.system(size: 12))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.gray)
                    }
                    .padding(.bottom, 4)
                }
            }
        }
    }
}
