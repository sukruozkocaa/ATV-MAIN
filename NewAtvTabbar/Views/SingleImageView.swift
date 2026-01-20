//
//  SingleImageView.swift
//  NewAtvTabbar
//
//  Created by Mehmet Can Şimşek on 20.01.2026.
//


import SwiftUI

struct SingleImageView: View {
    let item: SingleImageItem
    var config: SectionConfig?
    
    var body: some View {
        UniversalCardContainer(config: config, isSingleImage: true) { containerWidth in
            UniversalImageView(
                url: item.src,
                frameWidth: containerWidth,
                config: config,
                contentMode: .fit
            )
        }
    }
}
