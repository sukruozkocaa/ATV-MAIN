//
//  ScrollOffsetPreferenceKey.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 20.01.2026.
//

import Foundation
import SwiftUI

// MARK: - Scroll Offset PreferenceKey
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
