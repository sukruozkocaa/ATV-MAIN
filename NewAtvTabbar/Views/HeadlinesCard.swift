//
//  HeadlinesCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct HeadlinesCard: View {
    let item: NewsItem
    var itemCount: Int = 1
    var config: SectionConfig?
    
    private var cardWidth: CGFloat {
        return LayoutUtils.calculateCellWidth(config: config, itemCount: itemCount)
    }
    
    private var imageHeight: CGFloat {
        return LayoutUtils.calculateImageHeight(config: config, frameWidth: cardWidth)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            UniversalImageView(
                url: item.imageBig ?? item.image,
                frameWidth: cardWidth,
                width: cardWidth,
                height: imageHeight,
                config: config
            )
            
            // Gradient Overlay
            Color(hex: "FF141518").bottomScrim
            .frame(width: cardWidth, height: imageHeight * 0.2)
            
            // Content
            VStack(spacing: 12) {
                Spacer()
                
                // Info Row
                HStack(spacing: 8) {
                    Text("YENİ DİZİ")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    
                    Text(item.spot ?? "Detaylar")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                // Buttons
                GeometryReader { geometry in
                    let spacing: CGFloat = 12
                    let availableWidth = geometry.size.width - spacing
                    
                    HStack(spacing: spacing) {

                        Button(action: {}) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Son Bölümü İzle")
                                    .fontWeight(.semibold)
                                    // Metnin sığmaması durumunda küçülmesini engellemek için
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(width: availableWidth * 0.60)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("Detaylar")
                                    .fontWeight(.bold)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(width: availableWidth * 0.40)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .frame(height: 44)
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .padding(.bottom, 38)
            .frame(width: cardWidth, height: imageHeight)
            

        }
        .frame(width: cardWidth, height: imageHeight)
        .clipped()
        .cornerRadius(LayoutUtils.calculateImageRadius(config: config, frameWidth: cardWidth))
    }
}
