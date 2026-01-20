//
//  SectionContentView.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct SectionContentView: View {
    let data: SectionData
    
    var body: some View {
        switch data.template {
        case .headlines:
            if let news = data.news {
                InfiniteCarouselView(items: news, config: data.config) { item in
                    HeadlinesCard(item: item, config: data.config)
                }
            }
            
        case .program:
            if let videos = data.videos {
                SectionLayoutBuilder(items: videos, config: data.config) { item in
                    ProgramCard(item: item, config: data.config)
                }
            }
            
        case .broadcast:
            if let streams = data.streams {
                SectionLayoutBuilder(items: streams, config: data.config) { item in
                    StreamCard(item: item, config: data.config)
                }
            }
            
        case .singleImage:
            if let single = data.singleImage {
                SingleImageView(item: single, config: data.config)
            }
            
        case .cardFullImage1, .cardFullImage2:
            if let news = data.news {
                SectionLayoutBuilder(items: news, config: data.config) { item in
                    FullImageCard(item: item, config: data.config)
                }
            } else if let videos = data.videos {
                SectionLayoutBuilder(items: videos, config: data.config) { item in
                    VideoCard(item: item, config: data.config)
                }
            }
            
        case .cardTopImage1, .cardFullImage3:
            if let videos = data.videos {
                SectionLayoutBuilder(items: videos, config: data.config) { item in
                    VideoCard(item: item, config: data.config)
                }
            } else if let news = data.news {
                SectionLayoutBuilder(items: news, config: data.config) { item in
                    FullImageCard(item: item, config: data.config)
                }
            }
            
        default:
            EmptyView()
        }
    }
}
