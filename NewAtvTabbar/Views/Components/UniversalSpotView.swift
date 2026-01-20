//
//  UniversalSpotView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct UniversalSpotView: View {
    let text: String?
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    let config: SectionConfig?
    
    var body: some View {
        if let text = text, !text.isEmpty {
            Text(text)
                .font(config?.spot?.fontSize.map { Font.system(size: CGFloat($0)) } ?? .caption)
                .foregroundColor(config?.spot?.fontColorDark.map { Color(hex: $0) } ?? .gray)
                .lineLimit(config?.spot?.maxLines ?? 1)
                .multilineTextAlignment(textAlignment)
                .frame(width: width, height: height, alignment: alignmentFromTextData)
        }
    }
    
    private var alignmentFromTextData: Alignment {
        switch config?.spot?.align?.lowercased() {
         case "center": return .center
         case "right": return .trailing
         default: return .leading
         }
    }
    
    private var textAlignment: TextAlignment {
        switch config?.spot?.align?.lowercased() {
        case "center": return .center
        case "right": return .trailing
        default: return .leading
        }
    }
}
