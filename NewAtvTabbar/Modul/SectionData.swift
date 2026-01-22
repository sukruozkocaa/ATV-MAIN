//
//  SectionData.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import Foundation
import SwiftUI

// MARK: - API Response
struct APIResponse: Codable {
    let meta: Meta
    let data: [SectionData]
}

struct Meta: Codable {
    let statusCode: Int
    let message, description, brand: String
    let redirect: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message, description, brand, redirect, createdAt
    }
}

// MARK: - Section Data
struct SectionData: Codable, Identifiable {
    let id = UUID()
    let isActiveIOS: Bool?
    let config: SectionConfig
    let news: [NewsItem]?
    let streams: [StreamItem]?
    let videos: [VideoItem]?
    let singleImage: SingleImageItem?
    
    let videoTypeID: Int?
    
    // Manual helper to determine what "type" of section this is based on template
    var template: SectionTemplate? {
        config.widget?.template
    }
    
    enum CodingKeys: String, CodingKey {
        case config, news, streams, videos, singleImage, isActiveIOS
        case videoTypeID = "videoTypeId"
    }
}

// MARK: - Items
struct NewsItem: Codable, Identifiable {
    let id = UUID()
    let apiId: String?
    let title: String?
    let spot: String?
    let image: String?
    let imageBig: String?
    let external: String?
    
    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case title, spot, image, imageBig, external
    }
}

struct StreamItem: Codable, Identifiable {
    let id = UUID()
    let title: String?
    let image: String?
    let hour: String?
    let minute: String?
    let text: String? // "08:00"
    let isLive: Bool?
    let dayName: String?
    
    enum CodingKeys: String, CodingKey {
        case title, image, hour, minute, text, isLive, dayName
    }
}

struct VideoItem: Codable, Identifiable {
    let id = UUID()
    let title: String?
    let spot: String?
    let image: String?
    let date: String?
    let imageBig: String?
    let external: String?
    let showAd: Bool?
    let episode: Int?
    let season: Int?
    let videoTypeID: Int?
    let currentDuration: Double?
    let totalDuration: Double?
    
    var progress: Double? {
        guard let current = currentDuration, let total = totalDuration, total > 0 else { return nil }
        return current / total
    }

    enum CodingKeys: String, CodingKey {
        case title, spot, image, imageBig, external, showAd, episode, season, date
        case videoTypeID = "videoTypeId"
        case currentDuration, totalDuration
    }
}

struct SingleImageItem: Codable, Identifiable {
    let id = UUID()
    let src: String?
    let external: String?


    enum CodingKeys: String, CodingKey {
        case src, external
    }
}

// MARK: - Configs
struct SectionConfig: Codable {
    let widget: WidgetConfig?
    let cell: CellConfig?
    let title: TitleConfig?
    let spot: SpotConfig?
    let image: ImageConfig?
    let icon: IconConfig?
    let indicator: IndicatorConfig?
    let widgetTitle: WidgetTitleConfig?
    let date: DateConfig?
    let progressBar: ProgressBarConfig?
}

struct ProgressBarConfig: Codable {
    let isActive: Bool?
    let color: String?
}

struct DateConfig: Codable {
    let fontColorDark: String?
    let fontSize: Int?
    let isActive: Bool?
}

struct WidgetConfig: Codable {
    let template: SectionTemplate
    let type: String?
    let columnCount: Int?
    let rowCount: Int?
    let bgColorDark: String?
    let bgColorLight: String?
    let padding: Padding?
    let isGradient: Bool?
    let decorationView: DecorationViewConfig? // Seen in JSON
}

enum SectionTemplate: String, Codable {
    case headlines
    case broadcast
    case singleImage
    case cardFullImage1
    case cardFullImage2
    case cardTopImage1
    case cardFullImage3
    case cardLeftImage1
    case cardLeftImage2
    case columnistLeftImage1
    case columnistLeftImage2
    case columnistLeftImage3
    case program
    case topList
    case newSeries
    case discovery
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = SectionTemplate(rawValue: rawValue ?? "") ?? .unknown
    }
}

struct DecorationViewConfig: Codable {
    let isActive: Bool?
    let type: String?
}

struct CellConfig: Codable {
    let bgColorDark: String?
    let bgColorDarkDeselect: String?
    let bgColorLight: String?
    let bgColorLightDeselect: String?
    let borderColor: String?
    let borderIsActive: Bool?
    let radius: Double?
    let ratio: Double?
    let itemSpacer: Double?
    let shadowIsActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case bgColorDark, bgColorDarkDeselect, bgColorLight, bgColorLightDeselect
        case borderColor, borderIsActive, radius, ratio, itemSpacer, shadowIsActive
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bgColorDark = try? container.decode(String.self, forKey: .bgColorDark)
        bgColorDarkDeselect = try? container.decode(String.self, forKey: .bgColorDarkDeselect)
        bgColorLight = try? container.decode(String.self, forKey: .bgColorLight)
        bgColorLightDeselect = try? container.decode(String.self, forKey: .bgColorLightDeselect)
        borderColor = try? container.decode(String.self, forKey: .borderColor)
        borderIsActive = try? container.decode(Bool.self, forKey: .borderIsActive)
        shadowIsActive = try? container.decode(Bool.self, forKey: .shadowIsActive)
        
        // Robust Double Decoding
        if let val = try? container.decode(Double.self, forKey: .radius) {
            radius = val
        } else if let str = try? container.decode(String.self, forKey: .radius) {
            radius = Double(str.replacingOccurrences(of: ",", with: "."))
        } else {
            radius = nil
        }
        
        if let val = try? container.decode(Double.self, forKey: .ratio) {
            ratio = val
        } else if let str = try? container.decode(String.self, forKey: .ratio) {
            ratio = Double(str.replacingOccurrences(of: ",", with: "."))
        } else {
            ratio = nil
        }
        
        if let val = try? container.decode(Double.self, forKey: .itemSpacer) {
            itemSpacer = val
        } else if let str = try? container.decode(String.self, forKey: .itemSpacer) {
            itemSpacer = Double(str.replacingOccurrences(of: ",", with: "."))
        } else {
            itemSpacer = nil
        }
    }
}

struct TitleConfig: Codable {
    let fontColorDark: String?
    let fontSize: Int?
    let isActive: Bool?
    let text: String?
    let align: String?
    let fontType: String?
    let maxLines: Int?
    let verticalAlignment: String?
}

struct SpotConfig: Codable {
    let fontColorDark: String?
    let fontSize: Int?
    let isActive: Bool?
    let align: String?
    let fontType: String?
    let maxLines: Int?
    let scrollBehaviour: String?
}

struct ImageConfig: Codable {
    let radius: Double?
    let size: String?
    let weight: Double?
    let padding: Padding?
}

struct Padding: Codable {
    let bottom, left, right, top: Double?
    
    var edgeInsets: EdgeInsets {
        EdgeInsets(
            top: CGFloat(top ?? 0),
            leading: CGFloat(left ?? 0),
            bottom: CGFloat(bottom ?? 0),
            trailing: -CGFloat(right ?? 0)
        )
    }
}

struct IconConfig: Codable {
    let isActive: Bool?
    let type: String?
    let position: String?
    let size: Double?
}

struct IndicatorConfig: Codable {
    let isActive: Bool?
    let borderColor: String?
    let height: Double?
    let isOverImage: Bool?
    let selectedColor: String?
    let showIndex: Bool?
    let type: String?
    let unselectedColor: String?
}

struct WidgetTitleConfig: Codable {
    let text: String?
    let fontColorDark: String?
    let fontSize: Int?
    let spacer: Double?
    let fontType: String?
    let redirectUrl: String?
}
