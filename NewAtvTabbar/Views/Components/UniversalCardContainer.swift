//
//  UniversalCardContainer.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct UniversalCardContainer<Content: View>: View {
    let config: SectionConfig?
    let width: CGFloat?
    let content: (CGFloat) -> Content
    var aligment: Alignment = .leading
    var isSingleImage: Bool = false
    
    var calculatedWidth: CGFloat {
        if let width { return width }
        if isSingleImage {
            let padding = config?.widget?.padding
            let horizontalInset = (padding?.left ?? 0) + (padding?.right ?? 0)
            return UIScreen.main.bounds.width - horizontalInset
        }
        return LayoutUtils.calculateCellWidth(config: config)
    }
    
    init(config: SectionConfig?, width: CGFloat? = nil, aligment: Alignment = .leading, isSingleImage: Bool = false, @ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.config = config
        self.width = width
        self.aligment = aligment
        self.isSingleImage = isSingleImage
        self.content = content
    }
    
    var body: some View {
        let cardRadius = config?.cell?.radius ?? 12
        
        content(calculatedWidth)
            .frame(width: calculatedWidth, alignment: aligment)
            .background(config?.cell?.bgColorDark.map { Color(hex: $0) } ?? Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cardRadius)
                    .stroke(config?.cell?.borderColor.map { Color(hex: $0) } ?? .clear, lineWidth: (config?.cell?.borderIsActive ?? false) ? 1 : 0)
            )
    }
}
