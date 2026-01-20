//
//  StreamCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct StreamCard: View {
    let item: StreamItem
    var itemCount: Int = 1
    var config: SectionConfig?
    
    private var cardWidth: CGFloat {
        return LayoutUtils.calculateCellWidth(config: config, itemCount: itemCount)
    }
    
    private var imageHeight: CGFloat {
        return LayoutUtils.calculateImageHeight(config: config, frameWidth: cardWidth)
    }
    
    private var imageWidth: CGFloat {
        return LayoutUtils.calculateImageWidth(calculatedHeight: imageHeight, config: config)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Image Area
            UniversalImageView(
                url: item.image,
                frameWidth: cardWidth,
                config: config
            )
            .frame(width: imageWidth, height: imageHeight)
            .overlay(alignment: .topTrailing) {
                if item.isLive == true {
                    Text("CANLI")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(8)
                }
            }
            
            // Info Area
            VStack(alignment: .leading, spacing: 4) {
                if let text = item.text {
                    Text(text)
                        .font(config?.date?.fontSize.map { Font.system(size: CGFloat($0)) } ?? .caption)
                        .fontWeight(.bold)
                        .foregroundColor(config?.date?.fontColorDark.map { Color(hex: $0) } ?? .white)
                }
                
                UniversalTitleView(text: item.title, config: config)
            }
        }
        .frame(width: cardWidth)
    }
}
