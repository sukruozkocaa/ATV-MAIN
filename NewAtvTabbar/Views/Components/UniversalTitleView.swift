//
//  UniversalTitleView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct UniversalTitleView: View {
    let text: String?
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    let config: SectionConfig?
    
    var body: some View {
        if let text = text, !text.isEmpty {
            Text(text)
                .font(config?.title?.fontSize.map { Font.system(size: CGFloat($0)) } ?? .headline)
                .foregroundColor(config?.title?.fontColorDark.map { Color(hex: $0) } ?? .white)
                .lineLimit(config?.title?.maxLines ?? 2)
                .multilineTextAlignment(textAlignment)
                .frame(width: width, height: height, alignment: alignmentFromTextData)
        }
    }
    
    private var alignmentFromTextData: Alignment {
         switch config?.title?.align {
         case "center": return .center
         case "right": return .trailing
         default: return .leading
         }
    }
    
    private var textAlignment: TextAlignment {
        switch config?.title?.align {
        case "center": return .center
        case "right": return .trailing
        default: return .leading
        }
    }
}
