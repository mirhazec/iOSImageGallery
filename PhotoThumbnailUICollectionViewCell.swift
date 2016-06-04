//
//  PhotoThumbnailUICollectionViewCell.swift
//  iOSImageGallery
//
//  Created by Mirha Zec on 6/4/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import UIKit

class PhotoThumbnailUICollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(image:UIImage,name:String) {
        self.imageView.image = image
        self.imageName.text = name
    }
    
   
}
