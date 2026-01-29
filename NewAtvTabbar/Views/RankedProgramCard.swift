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
            HStack(alignment: .bottom, spacing: 0) {
                // Sıralama Numarası
                VStack {
                    Spacer()
                    Text("\(rank)")
                        .font(.custom("Vazirmatn-Bold", size: 120.0))
                        .foregroundColor(Color.init(hex: "111518"))
                        .textStroke(
                            size: 2,
                            gradient: LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .white, location: 0.0),
                                    .init(color: .white.opacity(0.7), location: 0.3),
                                    .init(color: Color.init(hex: "111518").opacity(0.7), location: 0.63),
                                    .init(color: Color.init(hex: "111518").opacity(0.8), location: 0.9),
                                    .init(color: Color.init(hex: "111518"), location: 1.0)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 120.0)
                        .offset(y: 30.0)
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
