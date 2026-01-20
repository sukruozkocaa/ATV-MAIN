//
//  FullImageCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct FullImageCard: View {
    let item: NewsItem
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
        UniversalCardContainer(config: config, width: cardWidth) {
            VStack(alignment: .leading, spacing: 0) {
                // Image Area
                UniversalImageView(
                    url: item.image,
                    frameWidth: cardWidth,
                    config: config
                )
                .frame(width: imageWidth, height: imageHeight)
            }
        }
    }
}
