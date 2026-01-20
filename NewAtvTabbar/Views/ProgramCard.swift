//
//  ProgramCard.swift
//  ATV
//
//  Created by Antigravity on 19.01.2026.
//

import SwiftUI



struct ProgramCard: View {
    let item: VideoItem
    var itemCount: Int = 1
    var config: SectionConfig?
    
    // MARK: - Layout Calculations
    private var cardWidth: CGFloat {
        return LayoutUtils.calculateCellWidth(config: config, itemCount: itemCount)
    }
    
    private var imageHeight: CGFloat {
         return LayoutUtils.calculateImageHeight(config: config, frameWidth: cardWidth)
    }
    
    private var imageWidth: CGFloat {
        return LayoutUtils.calculateImageWidth(calculatedHeight: imageHeight, config: config)
    }
    
    private var iconAlignment: Alignment {
        guard let position = config?.icon?.position else { return .topTrailing }
        switch position {
        case "center": return .center
        case "topLeft": return .topLeading
        case "topRight": return .topTrailing
        case "bottomLeft": return .bottomLeading
        case "bottomRight": return .bottomTrailing
        default: return .topTrailing
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - Image Area with Overlays
            UniversalImageView(
                url: item.image,
                width: imageWidth,
                height: imageHeight,
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
            .overlay(alignment: .bottom) {
                // Progress Bar
                if config?.progressBar?.isActive == true, let progress = item.progress {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(height: 4)
                        
                        Rectangle()
                            .fill(Color(hex: config?.progressBar?.color ?? "#FF0000")) 
                            .frame(width: imageWidth * CGFloat(progress), height: 4)
                    }
                    .frame(height: 4)
                    .mask(RoundedRectangle(cornerRadius: 2))
                    .padding(.bottom, 8)
                    .padding(.horizontal, 8)
                }
            }
            .overlay(alignment: iconAlignment) {
                // Notification Icon (Dynamic Position)
                if config?.icon?.isActive == true {
                    Button {
                        // Action for notification
                    } label: {
                        let iconSize = CGFloat(config?.icon?.size ?? 26) // Use config size or default to 26
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: iconSize, height: iconSize)
                            
                            Image(systemName: config?.icon?.type ?? "bell")
                                .font(.system(size: iconSize * 0.5)) // Scale icon relative to container
                                .foregroundColor(.white)
                        }
                    }
                    .padding(8)
                }
            }
            
            // MARK: - Text Area
            VStack(alignment: .leading, spacing: 4) {
                if let title = item.title {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white) // Assuming dark theme based on image
                        .lineLimit(1)
                }
                
                if let spot = item.spot {
                    Text(spot)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 4) // Slight padding alignment
        }
        .frame(width: cardWidth)
    }
}

// MARK: - Helper Shape for Custom Corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
