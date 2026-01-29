//
//  TextStrokeModifier.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 29.01.2026.
//

import Foundation
import SwiftUI

struct TextStrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeGradient: LinearGradient
    
    init(strokeSize: CGFloat = 1, strokeColor: Color = .blue) {
        self.strokeSize = strokeSize
        self.strokeGradient = LinearGradient(
            colors: [strokeColor],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    init(strokeSize: CGFloat = 1, gradient: LinearGradient) {
        self.strokeSize = strokeSize
        self.strokeGradient = gradient
    }
    
    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }
    
    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .background(
                // Shape is masked to create the stroke with gradient
                strokeGradient
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }
    
    func mask(content: Content) -> some View {
        Canvas { context, size in
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            let diagonal: CGFloat = 1/sqrt(2) * strokeSize
            content
                .tag(id)
                .overlay {
                    // Copies of text content shifted in 8 directions
                    ZStack {
                        // Top left
                        content.offset(x: -diagonal, y: -diagonal)
                        // Top
                        content.offset(x:  0, y: -strokeSize)
                        // Top right
                        content.offset(x:  diagonal, y: -diagonal)
                        // Right
                        content.offset(x:  strokeSize, y: 0)
                        // Bottom right
                        content.offset(x:  diagonal, y:  diagonal)
                        // Bottom
                        content.offset(x:  0, y: strokeSize)
                        // Bottom left
                        content.offset(x: -diagonal, y:  diagonal)
                        // Left
                        content.offset(x:  -strokeSize, y: 0)
                    }
                }
        }
    }
}

