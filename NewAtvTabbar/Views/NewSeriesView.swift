//
//  NewSeriesView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewSeriesView: View {
    let item: VideoItem?
    let newsItem: NewsItem?
    var config: SectionConfig?
    
    init(item: VideoItem? = nil, newsItem: NewsItem? = nil, config: SectionConfig? = nil) {
        self.item = item
        self.newsItem = newsItem
        self.config = config
    }
    
    private var imageUrl: String? {
        item?.imageBig ?? item?.image ?? newsItem?.imageBig ?? newsItem?.image
    }
    
    private var title: String? {
        item?.title ?? newsItem?.title
    }
    
    private var genres: String? {
        item?.spot ?? newsItem?.spot
    }
    
    private var padding: CGFloat {
        CGFloat(config?.widget?.padding?.left ?? 20)
    }
    
    var body: some View {
        UniversalCardContainer(config: config) { containerWidth in
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = imageUrl {
                    ZStack(alignment: .bottomLeading) {
                        // Poster Image
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
                        .frame(width: containerWidth)
                        .frame(height: 450)
                        .clipped()
                        
                        // Bottom Gradient Overlay
                        LinearGradient(
                            colors: [.clear, Color.black.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 250.0)
                        .frame(width: containerWidth, alignment: .bottom)
                                                
                        VStack {
                            HStack(alignment: .top) {
                                Text("YENİ DİZİ")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.white)
                                    .clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .bottomRight]))
                                
                                Spacer()
                                
                                // TOP 10 Badge
                                ZStack {
                                    RoundedRectangle(cornerRadius: .zero)
                                        .fill(Color.red)
                                        .clipShape(RoundedCorner(radius: 8, corners: [.bottomLeft, .topRight]))
                                }
                                .frame(width: 44.0, height: 44.0)
                                .overlay(
                                    VStack(spacing: .zero){
                                        Text("TOP")
                                            .font(.system(size: 12.0, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("10")
                                            .font(.system(size: 21.0, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                )
                            }
                            
                            Spacer()
                            
                            if let genres = genres {
                                Text(genres)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(.horizontal, 12)
                                    .padding(.bottom, 15.0)
                            }
                            
                            
                            Button(action: {
                                // Handle watch action
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("İlk Bölümü İzle")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                            .background(.clear)
                            .padding(.horizontal, 20.0)
                            .padding(.bottom, 20.0)
                        }
                    }
                }
            }
        }
    }
}
