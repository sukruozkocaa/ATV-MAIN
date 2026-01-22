//
//  RankedProgramCard.swift
//  NewAtvTabbar
//
//  Created by Mehmet Can Şimşek on 22.01.2026.
//

import SwiftUI

struct RankedProgramCard: View {
    let item: VideoItem
    var config: SectionConfig?
    let rank: Int
    
    var body: some View {
        let rankSpacing: CGFloat = 50
        UniversalCardContainer(config: config) { containerWidth in
            let imageHeight = LayoutUtils.calculateImageHeight(config: config, frameWidth: containerWidth - rankSpacing)
            
            HStack(alignment: .bottom, spacing: 0) {
                // Sıralama Numarası
                VStack {
                    Spacer()
                    Image("rank_\(rank)")
                        .resizable()
                        .scaledToFill()
                        .frame(height: imageHeight)
                        .padding(.trailing, rank == 1 ?  -50 : rank == 2 ? -20 : -10)
                }
                .frame(width: rankSpacing)
                
                // Dizi Resmi
                UniversalImageView(
                    url: item.image,
                    frameWidth: containerWidth - rankSpacing,
                    config: config
                )
                .overlay(alignment: .topLeading) {
                    if config?.date?.isActive == true, let date = item.date, !date.isEmpty {
                        Text(date)
                            .font(.system(size: CGFloat(config?.date?.fontSize ?? 10), weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .bottomRight]))
                    }
                }
            }
        }
    }
}
