//
//  GenieAnimateView.swift
//  Animations
//
//  Created by Şükrü on 8.12.2025.
//

import Foundation
import SwiftUI

struct GenieAnimatedView<Content: View>: UIViewRepresentable {
    let size: CGFloat
    @Binding var viewIsIn: Bool
    let duration: Double
    let targetRect: CGRect
    let targetEdge: RectEdge
    let content: () -> Content
    let onAnimationComplete: () -> Void
    var onProgressUpdate: ((CGFloat) -> Void)? = nil
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        hostingController.view.addGestureRecognizer(panGesture)
        hostingController.view.isUserInteractionEnabled = true
        
        containerView.addSubview(hostingController.view)
        context.coordinator.genieView = hostingController.view
        context.coordinator.hostingController = hostingController
        context.coordinator.contentBuilder = content // ✅ Content builder'ı sakla
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let genieView = context.coordinator.genieView else { return }
        
        if !context.coordinator.isInitialized {
            genieView.center = CGPoint(x: uiView.bounds.midX, y: uiView.bounds.midY)
            context.coordinator.isInitialized = true
        }
        
        if let hostingController = context.coordinator.hostingController {
            hostingController.rootView = content()
        }
        
        // ✅ Content builder'ı güncelle
        context.coordinator.contentBuilder = content
        context.coordinator.onProgressUpdate = onProgressUpdate
        
        if context.coordinator.lastViewIsIn != viewIsIn {
            context.coordinator.lastViewIsIn = viewIsIn
            context.coordinator.performAnimation(
                view: genieView,
                viewIsIn: viewIsIn,
                targetRect: targetRect,
                targetEdge: targetEdge,
                duration: duration,
                completion: onAnimationComplete
            )
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        var genieView: UIView?
        var hostingController: UIHostingController<Content>?
        var contentBuilder: (() -> Content)? // ✅ Content builder
        var lastViewIsIn: Bool = false
        var isAnimating: Bool = false
        var isInitialized: Bool = false
        var onProgressUpdate: ((CGFloat) -> Void)?
        
        var displayLink: CADisplayLink?
        var animationStartTime: CFTimeInterval = 0
        var animationDuration: Double = 0
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard !lastViewIsIn && !isAnimating else { return }
            
            guard let view = gesture.view,
                  let superview = view.superview else { return }
            
            let translation = gesture.translation(in: superview)
            
            if gesture.state == .changed {
                var newCenter = view.center
                newCenter.x += translation.x
                newCenter.y += translation.y
                
                let minX = 20 + view.bounds.width / 2
                let maxX = superview.bounds.width - 20 - view.bounds.width / 2
                let minY = 20 + view.bounds.height / 2
                let maxY = superview.bounds.height - 20 - view.bounds.height / 2
                
                newCenter.x = max(minX, min(newCenter.x, maxX))
                newCenter.y = max(minY, min(newCenter.y, maxY))
                
                view.center = newCenter
                gesture.setTranslation(.zero, in: superview)
            }
        }
        
        @objc func updateAnimationProgress() {
            let currentTime = CACurrentMediaTime()
            let elapsed = currentTime - animationStartTime
            let progress = min(elapsed / animationDuration, 1.0)
            
            // ✅ Progress callback'i main thread'de çağır
            DispatchQueue.main.async { [weak self] in
                self?.onProgressUpdate?(CGFloat(progress))
                
                // ✅ Content'i güncelle
                if let hostingController = self?.hostingController,
                   let contentBuilder = self?.contentBuilder {
                    hostingController.rootView = contentBuilder()
                }
            }
            
            if progress >= 1.0 {
                displayLink?.invalidate()
                displayLink = nil
            }
        }
        
        func performAnimation(view: UIView, viewIsIn: Bool, targetRect: CGRect, targetEdge: RectEdge, duration: Double, completion: @escaping () -> Void) {
            guard targetRect != .zero else { return }
            
            isAnimating = true
            
            let endRect = targetRect.insetBy(dx: 5.0, dy: 5.0)
            
            if viewIsIn {
                // ✅ Başlangıçta progress 0.0
                onProgressUpdate?(0.0)
                if let hostingController = hostingController,
                   let contentBuilder = contentBuilder {
                    hostingController.rootView = contentBuilder()
                }
                
                // Display link başlat
                animationDuration = duration
                animationStartTime = CACurrentMediaTime()
                displayLink?.invalidate()
                displayLink = CADisplayLink(target: self, selector: #selector(updateAnimationProgress))
                displayLink?.add(to: .main, forMode: .common)
                
                view.isUserInteractionEnabled = false
                view.genieInTransition(duration: duration, destinationRect: endRect, destinationEdge: targetEdge) { [weak self] in
                    guard let self = self else { return }
                    self.isAnimating = false
                    
                    // Display link'i temizle
                    self.displayLink?.invalidate()
                    self.displayLink = nil
                    
                    // ✅ Son güncelleme
                    DispatchQueue.main.async {
                        self.onProgressUpdate?(1.0)
                        if let hostingController = self.hostingController,
                           let contentBuilder = self.contentBuilder {
                            hostingController.rootView = contentBuilder()
                        }
                        completion()
                    }
                }
            } else {
                // Geri animasyonda
                displayLink?.invalidate()
                displayLink = nil
                onProgressUpdate?(0.0)
                if let hostingController = hostingController,
                   let contentBuilder = contentBuilder {
                    hostingController.rootView = contentBuilder()
                }
                
                view.genieOutTransition(duration: duration, startRect: endRect, startEdge: targetEdge) { [weak self] in
                    self?.isAnimating = false
                    view.isUserInteractionEnabled = true
                    completion()
                }
            }
        }
        
        deinit {
            displayLink?.invalidate()
        }
    }
}
