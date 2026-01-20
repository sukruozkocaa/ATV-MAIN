//
//  InfiniteCarouselView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI
import Combine
import UIKit

struct InfiniteCarouselView<Item, Content>: View where Item: Identifiable, Content: View {
    let items: [Item]
    let config: SectionConfig?
    let content: (Item) -> Content
    
    // Configurable multiplier effectively creates "infinite" scroll
    private let multiplier = 1000
    
    @State private var currentIndex: Int = 0
    // To control programmatic scrolling
    @State private var scrollToIndex: Int?
    
    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            let height = LayoutUtils.calculateImageHeight(config: config, frameWidth: UIScreen.main.bounds.width)
            
            ZStack(alignment: .bottom) {
                // UICollectionView Wrapper
                InfiniteCollectionView(
                    items: items,
                    multiplier: multiplier,
                    itemHeight: height,
                    scrollToIndex: $scrollToIndex,
                    onIndexChange: { index in
                        self.currentIndex = index % items.count
                    },
                    content: content
                )
                .frame(height: height)
                
                // Pagination Dots
                HStack(spacing: 6) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: currentIndex == index ? 8 : 6, height: currentIndex == index ? 8 : 6)
                            .animation(.spring(), value: currentIndex)
                    }
                }
                .padding(.bottom, 14)
            }
        }
    }
}

// MARK: - UIViewRepresentable

struct InfiniteCollectionView<Item: Identifiable, Content: View>: UIViewRepresentable {
    let items: [Item]
    let multiplier: Int
    let itemHeight: CGFloat
    @Binding var scrollToIndex: Int?
    let onIndexChange: (Int) -> Void
    let content: (Item) -> Content
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        
        cv.dataSource = context.coordinator
        cv.delegate = context.coordinator
        cv.register(HostingCell<Content>.self, forCellWithReuseIdentifier: "Cell")
        
        // Start in the middle
        DispatchQueue.main.async {
            let startMiddle = (items.count * multiplier) / 2
            // Align to first item of the set
            let alignedStart = startMiddle - (startMiddle % items.count)
            cv.scrollToItem(at: IndexPath(item: alignedStart, section: 0), at: .centeredHorizontally, animated: false)
            context.coordinator.currentIndex = alignedStart
        }
        
        return cv
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        // Handle programmatic scroll if needed via binding
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        var parent: InfiniteCollectionView
        var currentIndex: Int = 0
        
        init(_ parent: InfiniteCollectionView) {
            self.parent = parent
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.items.count * parent.multiplier
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HostingCell<Content>
            
            let actualIndex = indexPath.item % parent.items.count
            let item = parent.items[actualIndex]
            
            cell.host(parent.content(item))
            return cell
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            updateIndex(scrollView)
        }
        
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            updateIndex(scrollView)
        }
        
        private func updateIndex(_ scrollView: UIScrollView) {
            let width = scrollView.frame.width
            if width == 0 { return }
            let index = Int(round(scrollView.contentOffset.x / width))
            if index != currentIndex {
                currentIndex = index
                parent.onIndexChange(index)
            }
        }
    }
}

// MARK: - Hosting Cell

class HostingCell<Content: View>: UICollectionViewCell {
    private var hostingController: UIHostingController<Content>?
    
    func host(_ view: Content) {
        if let hc = hostingController {
            hc.rootView = view
        } else {
            let hc = UIHostingController(rootView: view)
            hc.view.backgroundColor = .clear
            contentView.addSubview(hc.view)
            hc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            hostingController = hc
        }
    }
}
