//
//  SectionLayoutBuilder.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct SectionLayoutBuilder<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let config: SectionConfig?
    let content: (Item) -> Content
    
    init(items: [Item], config: SectionConfig?, @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.config = config
        self.content = content
    }
    
    var body: some View {
        let type = effectiveType
        let rowCount = config?.widget?.rowCount ?? 1
        let columnCount = config?.widget?.columnCount ?? 1
        let itemSpacer = CGFloat(config?.cell?.itemSpacer ?? 16)
        let widgetPadding = config?.widget?.padding
        let leadingPadding = CGFloat(widgetPadding?.left ?? 20)
        let trailingPadding = CGFloat(widgetPadding?.right ?? 20)
        
        Group {
            if type == "horizontal" {
                ScrollView(.horizontal, showsIndicators: false) {
                    if rowCount > 1 {
                        // Multi-row horizontal grid
                        LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 0), count: rowCount), spacing: itemSpacer) {
                            ForEach(items) { item in
                                content(item)
                            }
                        }
                        .padding(.leading, leadingPadding)
                        .padding(.trailing, trailingPadding)
                    } else {
                        // Standard single-row list (LazyHStack handles variable heights better than flexible grid)
                        LazyHStack(alignment: .top, spacing: itemSpacer) {
                            ForEach(items) { item in
                                content(item)
                            }
                        }
                        .padding(.leading, leadingPadding)
                        .padding(.trailing, trailingPadding)
                    }
                }
            } else {
                // Vertical / Grid
                if columnCount > 1 {
                    // Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: itemSpacer), count: columnCount), spacing: itemSpacer) {
                        ForEach(items) { item in
                            content(item)
                        }
                    }
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
                } else {
                    // List (Single Column)
                    // Using LazyVStack for standard list
                    LazyVStack(spacing: itemSpacer) {
                        ForEach(items) { item in
                            content(item)
                        }
                    }
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
                }
            }
        }
    }
    
    // Logic from Modul.swift to force "vertical" if single item on certain templates
    private var effectiveType: String? {
        let verticalForcedTemplates: [SectionTemplate?] = [
            .cardLeftImage1, .cardLeftImage2,
            .columnistLeftImage1, .columnistLeftImage2, .columnistLeftImage3
        ]
        
        if verticalForcedTemplates.contains(config?.widget?.template) && items.count == 1 {
            return "vertical"
        }
        return config?.widget?.type
    }
}
