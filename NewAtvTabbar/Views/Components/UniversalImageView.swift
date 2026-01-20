//
//  UniversalImageView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

//struct UniversalImageView: View {
//    let url: String?
//    let frameWidth: CGFloat
//    let config: SectionConfig?
//    var contentMode: ContentMode = .fill
//    
//    private var paddingInsets: EdgeInsets {
//        return config?.image?.padding?.edgeInsets ?? EdgeInsets()
//    }
//
//    private var calculatedHeight: CGFloat {
//        return LayoutUtils.calculateImageHeight(config: config, frameWidth: frameWidth)
//    }
//    
//    private var calculatedWidth: CGFloat {
//        return LayoutUtils.calculateImageWidth(calculatedHeight: calculatedHeight, config: config)
//    }
//    
//    private var cornerRadius: CGFloat {
//        return CGFloat(config?.image?.radius ?? 0)
//    }
//
//    var body: some View {
//        VStack {
//            WebImage(url: URL(string: url ?? ""))
//                .resizable()
//                .indicator(.activity)
//                .transition(.fade(duration: 0.5))
//                .aspectRatio(contentMode: contentMode)
//                .frame(width: calculatedWidth, height: calculatedHeight)
//                .cornerRadius(cornerRadius)
//                .clipped()
//                .padding(paddingInsets)
//        }
//    }
//}

struct UniversalImageView: View {
    let url: String?
    let frameWidth: CGFloat
    let config: SectionConfig?
    var contentMode: ContentMode = .fill
    
    // Resmin kendi padding'i (Kart ile resim arasındaki boşluk)
    private var paddingInsets: EdgeInsets {
        return config?.image?.padding?.edgeInsets ?? EdgeInsets()
    }

    private var calculatedHeight: CGFloat {
        return LayoutUtils.calculateImageHeight(config: config, frameWidth: frameWidth)
    }
    
    private var calculatedWidth: CGFloat {
        return LayoutUtils.calculateImageWidth(calculatedHeight: calculatedHeight, config: config)
    }
    
    // Resmin KENDİ radius'u (İç radius)
    private var imageRadius: CGFloat {
        return CGFloat(config?.image?.radius ?? 0)
    }

    var body: some View {
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .aspectRatio(contentMode: contentMode)
            .frame(width: calculatedWidth, height: calculatedHeight)
            
            // ADIM 1: Önce resmin kendisine şeklini ver (İç Radius)
            .clipShape(RoundedRectangle(cornerRadius: imageRadius))
            
            // ADIM 2: Şekillenmiş resmin etrafına boşluk ekle
            .padding(paddingInsets)
    }
}
