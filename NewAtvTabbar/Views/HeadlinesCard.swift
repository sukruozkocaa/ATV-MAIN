//
//  HeadlinesCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct HeadlinesCard: View {
    let item: NewsItem
    var config: SectionConfig?
    
    var body: some View {
        UniversalCardContainer(config: config) { containerWidth in
            let imageHeight = LayoutUtils.calculateImageHeight(config: config, frameWidth: containerWidth)
            
            ZStack(alignment: .bottom) {
                // Image
                UniversalImageView(url: item.image, frameWidth: containerWidth, config: config)
                
                // Gradient Overlay
                Color(hex: "FF141518").bottomScrim
                    .frame(width: containerWidth, height: imageHeight * 0.2)
                
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
            }
        }
    }
}
