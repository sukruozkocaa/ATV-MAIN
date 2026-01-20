//
//  UniversalCardContainer.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct UniversalCardContainer<Content: View>: View {
    let config: SectionConfig?
    let width: CGFloat
    let content: Content
    
    init(config: SectionConfig?, width: CGFloat, @ViewBuilder content: () -> Content) {
        self.config = config
        self.width = width
        self.content = content()
    }
    
    var body: some View {
        content
            .background(config?.cell?.bgColorDark.map { Color(hex: $0) } ?? Color.clear)
            .cornerRadius(config?.cell?.radius ?? 12)
            .overlay(
                RoundedRectangle(cornerRadius: config?.cell?.radius ?? 12)
                    .stroke(config?.cell?.borderColor.map { Color(hex: $0) } ?? .clear, lineWidth: (config?.cell?.borderIsActive ?? false) ? 1 : 0)
            )
            .frame(width: width)
    }
}
