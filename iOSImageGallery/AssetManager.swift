//
//  AssetManager.swift
//  iOSImageGallery
//
//  Created by Mirha Zec on 6/4/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import Foundation
import Photos

class AssetManager: NSObject {
    
    var assetCollection = PHAssetCollection()
    var photoAssets = PHFetchResult()
    var images = [UIImage]()
    let imageManager = PHCachingImageManager()
    var assetImages: [PHAsset] = []
    
    func getPhotos() -> [UIImage] {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let imageAssets = PHAsset.fetchAssetsWithOptions(fetchOptions)
        
        imageAssets.enumerateObjectsUsingBlock { (object, count, stop) in
            if object is PHAsset {
                let asset = object as! PHAsset
                let imageSize = CGSize(width: asset.pixelWidth,height: asset.pixelHeight)
                self.assetImages.append(asset)
                let options = PHImageRequestOptions()
                options.deliveryMode = .FastFormat
                options.synchronous = true
                
                self.imageManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: .AspectFill, options: options, resultHandler: { [weak self]
                    image, info in
                    
                    self?.images.append(image!)

                    })
            }
        }
            return images
    }
    
    func getImageName(index:Int) -> String {
        
        return (assetImages[index].valueForKey("filename") as? String)!
        
    }
    
    func getTimeStamp(index:Int) -> NSDate {
        
         return assetImages[index].creationDate!
        
    }
}


