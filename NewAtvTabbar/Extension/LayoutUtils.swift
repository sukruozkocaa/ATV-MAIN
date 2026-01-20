//
//  LayoutUtils.swift
//  ATV
//
//  Created by Mehmet Can Şimşek on 19.01.2026.
//

import SwiftUI

struct LayoutUtils {
    
    static func calculateImageRadius(config: SectionConfig?, frameWidth: CGFloat) -> CGFloat {
        guard let config = config else { return 0 }
        
        let imageSize = config.image?.size ?? ""
        let imageSizeArray = imageSize.components(separatedBy: "x")
        
        if imageSizeArray.count == 2,
           let width = Double(imageSizeArray[0]),
           let height = Double(imageSizeArray[1]) {
            
            let imageRatio = config.image?.weight ?? 0
            let spacer = config.cell?.itemSpacer ?? 2
            let cellWidth = Double(frameWidth) - spacer
            
            let calculateHeight = imageRatio * cellWidth / width * height
            
            let radius = config.image?.radius ?? 0
            if radius == 50.0 {
                return CGFloat(calculateHeight / 2)
            } else {
                return CGFloat(radius)
            }
        }
        return CGFloat(config.image?.radius ?? 0)
    }
    
    static func calculateImageHeight(config: SectionConfig?, frameWidth: CGFloat) -> CGFloat {
        guard let config = config else { return 0 }
        
        let imageSize = config.image?.size ?? ""
        let imageSizeArray = imageSize.components(separatedBy: "x")
        
        // İkinci fonksiyondaki mantık: Array elemanlarının boş olup olmadığını kontrol et
        // (Güvenlik için 'count > 1' kontrolünü de ekledim ki crash olmasın)
        if imageSizeArray.count > 1, !imageSizeArray[0].isEmpty, !imageSizeArray[1].isEmpty {
            
            let width = Double(imageSizeArray[0]) ?? 0
            let height = Double(imageSizeArray[1]) ?? 0
            
            if width == 0 { return 0 }
            let imageRatio = Double(config.image?.weight ?? 0)
            let spacer = CGFloat(config.cell?.itemSpacer ?? 1 * 2)
            let cellWidth = Double(frameWidth - spacer)
            
            let calculateHeight = imageRatio * cellWidth / width * height
            
            return CGFloat(calculateHeight)
        }
        
        return 0
    }
    
    static func calculateCellWidth(config: SectionConfig?) -> CGFloat {
        guard let config = config else { return 0 }
        
        let screenWidth = UIScreen.main.bounds.width
        let columnCount = Double(config.widget?.columnCount ?? 1)
        let rowCount = config.widget?.rowCount ?? 1
        let type = config.widget?.type
        
        if let ratio = config.cell?.ratio, ratio > 0 {
            if type == "horizontal" {
                if rowCount > 1 {
                    return screenWidth * CGFloat(ratio / columnCount)
                } else {
                    return screenWidth * CGFloat(ratio)
                }
            } else {
                // Vertical or Default
                if columnCount > 1 {
                    return screenWidth * CGFloat(ratio * (1.0 / columnCount))
                } else {

                    if (ratio <= 0.0 || ratio >= 1.0) {
                        return screenWidth
                    } else {
                        return screenWidth * CGFloat(ratio)
                    }
                }
            }
        }
        
        return 160
    }
    
    static func calculateImageWidth(calculatedHeight: Double, config: SectionConfig?) -> Double {
        let imageSize = config?.image?.size ?? ""
        let imageSizeArray = imageSize.components(separatedBy: "x")
        if imageSizeArray.count == 2,
           let width = Double(imageSizeArray[0]),
           let height = Double(imageSizeArray[1]), height > 0 {
            return calculatedHeight / height * width
        }
        return 0
    }
    
}
