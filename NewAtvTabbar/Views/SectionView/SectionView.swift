//
//  SectionView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 4.01.2026.
//

import SwiftUI

enum SectionLayoutType {
    case horizontal(rows: Int = 1)
    case vertical(columns: Int = 2)
}

struct SectionView: View {
    let data: SectionData
    
    private var baseColor: Color {
        data.config.widget?.bgColorDark.map { Color(hex: $0) } ?? Color.clear
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            if let widgetTitle = data.config.widgetTitle?.text {
                HStack(spacing: 8) {
                    WidgetTitleView(
                        title: widgetTitle,
                        fontSize: data.config.widgetTitle?.fontSize.map { CGFloat($0) } ?? 20,
                        color: data.config.widgetTitle?.fontColorDark.map { Color(hex: $0) } ?? .white,
                        redirectUrl: data.config.widgetTitle?.redirectUrl
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, CGFloat(data.config.widget?.padding?.left ?? 20))
                .padding(.bottom, CGFloat(data.config.widgetTitle?.spacer ?? 10))
            }
            
            // Content
            contentView
        }
        .background(backgroundView)
        .zIndex(data.config.widget?.isGradient == true ? -1 : 0)
        .padding(.top,  CGFloat(data.config.widget?.padding?.top ?? 20))
        .padding(.bottom, CGFloat(data.config.widget?.padding?.bottom ?? 20))
    }
    
    @ViewBuilder
    var contentView: some View {
        SectionContentView(data: data)
    }
    
    @ViewBuilder
    var backgroundView: some View {
        if data.config.widget?.isGradient == true {
            let padding: CGFloat = 50

            baseColor
                .gradientVerticalSoftSpotlight
                .padding(.vertical, -padding)
                .padding(.bottom, -padding)
        } else {
            baseColor
        }
    }
}
