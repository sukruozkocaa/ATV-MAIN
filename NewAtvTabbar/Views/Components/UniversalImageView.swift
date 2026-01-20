//
//  UniversalCardContainer.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct UniversalImageView: View {
    let url: String?
    var frameWidth: CGFloat = UIScreen.main.bounds.width
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var contentMode: ContentMode = .fill
    var customPadding: EdgeInsets? = nil
    let config: SectionConfig?
    
    var body: some View {
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition
            .aspectRatio(contentMode: contentMode)
            .frame(width: width, height: height)
            .cornerRadius(LayoutUtils.calculateImageRadius(config: config, frameWidth: width ?? frameWidth))
            .padding(customPadding ?? EdgeInsets())
            .clipped()
    }
}
