//
//  SVGImgProcessor.swift
//  ProgressHUD
//
//  Created by user1000 on 27/06/2025.
//

import Kingfisher
import SwiftDraw
import UIKit


public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            return UIImage(svgData: data)
        }
    }
}
