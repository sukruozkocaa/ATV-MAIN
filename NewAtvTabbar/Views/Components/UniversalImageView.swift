//
//  UniversalImageView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct UniversalImageView: View {
    let url: String?
    let frameWidth: CGFloat
    let config: SectionConfig?
    var contentMode: ContentMode = .fill
    
    private var paddingInsets: EdgeInsets {
        return config?.image?.padding?.edgeInsets ?? EdgeInsets()
    }
    
    private var calculatedHeight: CGFloat {
        return LayoutUtils.calculateImageHeight(config: config, frameWidth: frameWidth)
    }
    
    private var calculatedWidth: CGFloat {
        return LayoutUtils.calculateImageWidth(calculatedHeight: calculatedHeight, config: config)
    }
    
    private var imageRadius: CGFloat {
        return CGFloat(config?.image?.radius ?? 0)
    }
    
    var body: some View {
        Group {
            if let urlString = url, urlString.hasPrefix("asset://") {
                let assetName = String(urlString.dropFirst(8))
                Image(assetName)
                    .resizable()
                
            } else {
                WebImage(url: URL(string: url ?? ""))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
            }
        }
        .aspectRatio(contentMode: contentMode)
        .frame(width: calculatedWidth, height: calculatedHeight)
        .cornerRadius(imageRadius)
        .padding(paddingInsets)
    }
}
