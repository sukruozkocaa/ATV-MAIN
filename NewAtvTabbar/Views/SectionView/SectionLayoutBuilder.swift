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
    let content: (Item, Int) -> Content
    
    init(items: [Item], config: SectionConfig?, @ViewBuilder content: @escaping (Item, Int) -> Content) {
        self.items = items
        self.config = config
        self.content = content
    }
    
    var body: some View {
        let type = config?.widget?.type
        let rowCount = config?.widget?.rowCount ?? 1
        let columnCount = config?.widget?.columnCount ?? 1
        let itemSpacer = CGFloat(config?.cell?.itemSpacer ?? 16)
        let widgetPadding = config?.widget?.padding
        let leadingPadding = CGFloat(widgetPadding?.left ?? 20)
        let trailingPadding = CGFloat(widgetPadding?.right ?? 20)
        
        let enumeratedItems = Array(items.enumerated())
        
        Group {
            if type == "horizontal" {
                ScrollView(.horizontal, showsIndicators: false) {
                    if rowCount > 1 {
                        // Multi-row horizontal grid
                        LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 0), count: rowCount), spacing: itemSpacer) {
                            ForEach(enumeratedItems, id: \.element.id) { index, item in
                                content(item, index)
                            }
                        }
                        .padding(.leading, leadingPadding)
                        .padding(.trailing, trailingPadding)
                    } else {
                        LazyHStack(alignment: .top, spacing: itemSpacer) {
                            ForEach(enumeratedItems, id: \.element.id) { index, item in
                                content(item, index)
                            }
                        }
                        .padding(.leading, leadingPadding)
                        .padding(.trailing, trailingPadding)
                    }
                }
            } else {
                // Vertical
                if columnCount > 1 {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: itemSpacer), count: columnCount), spacing: itemSpacer) {
                        ForEach(enumeratedItems, id: \.element.id) { index, item in
                            content(item, index)
                        }
                    }
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
                } else {
                    LazyVStack(spacing: itemSpacer) {
                        ForEach(enumeratedItems, id: \.element.id) { index, item in
                            content(item, index)
                        }
                    }
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
                }
            }
        }
    }
}
