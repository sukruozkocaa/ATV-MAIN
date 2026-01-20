//
//  VideoCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct VideoCard: View {
    let item: VideoItem
    var config: SectionConfig?
    
    var body: some View {
        UniversalCardContainer(config: config, aligment: .leading) { containerWidth in
            VStack(alignment: .leading, spacing: 8) {
                UniversalImageView(
                    url: item.image,
                    frameWidth: containerWidth,
                    config: config
                )
                .overlay {
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
        }
    }
}
