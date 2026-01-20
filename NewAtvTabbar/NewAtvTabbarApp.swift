//
//  NewAtvTabbarApp.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 2.01.2026.
//

import SwiftUI

@main
struct NewAtvTabbarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var isShowingSplash = true
    
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)
            } else {
                TabbarOptions2()
                    .transition(.identity)
            }
        }
    }
}
