//
//  FullImageCard.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct FullImageCard: View {
    let item: NewsItem
    var config: SectionConfig?
    
    private var title: String? {
        if config?.title?.isActive == true, let title = item.title  {
            return title
        }
        return nil
    }
    
    var body: some View {
        UniversalCardContainer(config: config) { containerWidth in
            let imagePadding = config?.image?.padding?.edgeInsets ?? EdgeInsets()
            let verticalImagePadding = imagePadding.top + imagePadding.bottom
            let rawImageHeight = LayoutUtils.calculateImageHeight(config: config, frameWidth: containerWidth)
            
            let hasTitle = title != nil
            let titleHeight: CGFloat = hasTitle ? 30 : 0
            let spacing: CGFloat = 6
            
            let finalImageHeight = rawImageHeight + verticalImagePadding
            let contentHeight = finalImageHeight + (hasTitle ? (titleHeight + spacing) : 0)
            
            
            VStack(alignment: .center, spacing: spacing) {
                // Image Area
                UniversalImageView(url: item.image, frameWidth: containerWidth, config: config)
                
                // Text Area
                if let title = title  {
                    UniversalTitleView(text: title, config: config)
                }
            }
            .frame(height: contentHeight)
        }
    }
}
