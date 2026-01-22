//
//  DiscoveryCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoveryCard: View {
    let item: NewsItem
    var config: SectionConfig?
    
    private var imageUrl: String? {
        item.imageBig ?? item.image
    }
    
    private var title: String? {
        item.title
    }
    
    var body: some View {
        UniversalCardContainer(config: config) { containerWidth in
            ZStack(alignment: .bottom) {
                // Main Background Image
                Group {
                    if let imageUrl = imageUrl {
                        if imageUrl.hasPrefix("asset://") {
                            let assetName = String(imageUrl.dropFirst(8))
                            Image(assetName)
                                .resizable()
                        } else {
                            WebImage(url: URL(string: imageUrl))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                        }
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: containerWidth)
                .frame(height: LayoutUtils.calculateImageHeight(config: config, frameWidth: containerWidth))
                .clipped()
                
                // Bottom Gradient Overlay
                LinearGradient(
                    colors: [.clear, Color.black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 150)
                .frame(width: containerWidth, alignment: .bottom)
                
                // Bottom Section with Circular Overlay and Title
                VStack(spacing: 10.0) {
                    // Circular Overlay Image with border spacing
                    if let imageUrl = imageUrl {
                        Group {
                            if imageUrl.hasPrefix("asset://") {
                                let assetName = String(imageUrl.dropFirst(8))
                                Image(assetName)
                                    .resizable()
                            } else {
                                WebImage(url: URL(string: imageUrl))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                            }
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .padding(4)
                        .background(
                            Circle()
                                .stroke(Color(hex: "#DF4A17"), lineWidth: 3)
                        )
                    }
                    
                    // Title
                    if let title = title {
                        Text(title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }
}
