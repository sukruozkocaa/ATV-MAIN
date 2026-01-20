//
//  VideoCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct VideoCard: View {
    let item: VideoItem
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
        VStack(alignment: .leading, spacing: 8) {
            UniversalImageView(
                url: item.image,
                width: imageWidth,
                height: imageHeight,
                config: config
            )
            .overlay {
                // Play Icon
                if config?.icon?.isActive == true {
                     Image(systemName: config?.icon?.type ?? "play.fill")
                        .font(.system(size: CGFloat(config?.icon?.size ?? 40)))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                } else {
                     Image(systemName: "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(radius: 4)
                }
            }
            
            UniversalTitleView(text: item.title, config: config)
        }
        .frame(width: cardWidth, alignment: .leading)
    }
}
