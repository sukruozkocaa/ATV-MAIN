//
//  SplashView.swift
//  NewAtvTabbar
//
//  Created by Şükrü on 2.01.2026.
//

import SwiftUI
import UIKit
import ImageIO
import WebKit

struct SplashView: View {
    var onGifFinished: () -> Void
    
    var body: some View {
        GIFView(gifName: "splash", onFinished: onGifFinished)
            .ignoresSafeArea()
    }
}

struct GIFView: UIViewRepresentable {
    let gifName: String
    let onFinished: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        guard let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let gifData = NSData(contentsOfFile: gifPath) else {
            // GIF bulunamazsa hemen yönlendir
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onFinished()
            }
            return containerView
        }
        
        // GIF süresini hesapla
        let gifDuration = calculateGIFDuration(data: gifData as Data)
        
        // UIImageView oluştur
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // GIF'i oynat
        if let animatedImage = UIImage.animatedImage(withAnimatedGIFData: gifData as Data) {
            imageView.image = animatedImage
        } else {
            // Fallback: WebView kullan
            return createWebView(gifData: gifData, duration: gifDuration)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // GIF bitince callback çağır
        DispatchQueue.main.asyncAfter(deadline: .now() + gifDuration) {
            onFinished()
        }
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    private func calculateGIFDuration(data: Data) -> TimeInterval {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return 3.0 // Varsayılan 3 saniye
        }
        
        let frameCount = CGImageSourceGetCount(source)
        var totalDuration: TimeInterval = 0
        
        for i in 0..<frameCount {
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                
                if let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
                    totalDuration += delayTime
                } else if let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                    totalDuration += delayTime
                }
            }
        }
        
        // Eğer süre 0 ise varsayılan değer kullan
        return totalDuration > 0 ? totalDuration : 3.0
    }
    
    private func createWebView(gifData: NSData, duration: TimeInterval) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        
        let base64String = gifData.base64EncodedString()
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                html, body {
                    width: 100%;
                    height: 100%;
                    overflow: hidden;
                    background-color: transparent;
                }
                body {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }
                img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }
            </style>
        </head>
        <body>
            <img src="data:image/gif;base64,\(base64String)">
        </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        // GIF süresi kadar bekle
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            onFinished()
        }
        
        return webView
    }
}

// UIImage extension for animated GIF
extension UIImage {
    static func animatedImage(withAnimatedGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: TimeInterval = 0
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                   let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                    
                    if let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
                        duration += delayTime
                    } else if let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                        duration += delayTime
                    }
                }
            }
        }
        
        if images.isEmpty {
            return nil
        }
        
        return UIImage.animatedImage(with: images, duration: duration > 0 ? duration : 0.1 * Double(count))
    }
}
