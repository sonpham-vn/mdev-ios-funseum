//
//  ImageMixer.swift
//  Funseum
//
//  Created by SonPT on 2021-12-07.
//

import Foundation
import SwiftUI

class ImageMixer {
    
    
    static func mix(topImageName: String, bottomImage: UIImage) ->  UIImage {
        var topImage = UIImage(named: topImageName)
        var size = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage.draw(in: areaSize)

        topImage!.draw(in: areaSize, blendMode: .normal, alpha: 0.8)

        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
}
