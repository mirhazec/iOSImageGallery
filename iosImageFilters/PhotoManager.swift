//
//  ImageManager.swift
//  iOSImageGallery
//
//  Created by Mirha Zec on 6/4/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import Foundation
import UIKit

class PhotoManager: NSObject {
    
    
    func negative(image: RGBA) -> RGBA {
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                var pixel = image.pixels[index]
                pixel.red = UInt8(255 - pixel.red)
                pixel.green = UInt8(255 - pixel.green)
                pixel.blue = UInt8(255 - pixel.blue)
                image.pixels[index] = pixel
            }
        }
        return image
    }
    
    func grayscale(image: RGBA) -> RGBA {
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                var pixel = image.pixels[index]
                let y =  0.21 * Double(pixel.red)  + 0.72 * Double(pixel.green) + 0.07 *  Double(pixel.blue)
                pixel.red = UInt8(y)
                pixel.green = UInt8(y)
                pixel.blue = UInt8(y)
                image.pixels[index] = pixel
            }
        }
        return image
    }
    
    func getRedHistogram(image: UIImage) -> [Double]{
        let rgba = RGBA(image: image)!
        var array = [Double]()
        for y in 0..<rgba.height {
            for x in 0..<rgba.width {
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                array.append(Double(pixel.red))
            }
        }
        return array
    }
    func getGreenHistogram(image: UIImage) -> [Double]{
        let rgba = RGBA(image: image)!
        var array = [Double]()
        for y in 0..<rgba.height {
            for x in 0..<rgba.width {
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                array.append(Double(pixel.green))
            }
        }
        return array
    }
    
    func getBlueHistogram(image: UIImage) -> [Double]{
        let rgba = RGBA(image: image)!
        var array = [Double]()
        for y in 0..<rgba.height {
            for x in 0..<rgba.width {
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                array.append(Double(pixel.blue))
            }
        }
        return array
    }
    
    func getGrayscaleImage(image:UIImage) ->UIImage {
        let rgba = RGBA(image: image)!
        return grayscale(rgba).toUIImage()!
    }
    
    func getNegativeImage(image:UIImage) -> UIImage {
        let rgba = RGBA(image: image)!
        return negative(rgba).toUIImage()!
    }
    
    
}