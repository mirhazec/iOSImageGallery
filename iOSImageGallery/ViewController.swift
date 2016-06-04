//
//  ViewController.swift
//  iOSImageGallery
//
//  Created by Mirha Zec on 6/4/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [UIImage]()
    let assetManager: AssetManager = AssetManager()
    var selectedIndex:Int?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItem()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.registerCells()
        self.images = assetManager.getPhotos()
    }
    
    func setNavigationItem() {
        self.navigationController?.navigationBar.hidden = false
        let button =  UIBarButtonItem.init(title: "Image from URL", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.insertUrl))
        self.navigationItem.rightBarButtonItem = button
    }

    
    // MARK: Actions
    
    func registerCells() {
        let PhotoThumbnailUICollectionViewCell = UINib(nibName: "PhotoThumbnailUICollectionViewCell", bundle:nil)
        collectionView.registerNib(PhotoThumbnailUICollectionViewCell, forCellWithReuseIdentifier: "PhotoThumbnailUICollectionViewCell")
    }
    
    // CollectionView Delegate functions
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoThumbnailUICollectionViewCell", forIndexPath: indexPath) as! PhotoThumbnailUICollectionViewCell
        cell.initCell(images[row],name: assetManager.getImageName(row))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Always display three images per row
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/3.5
        collectionViewSize.height = collectionViewSize.width
        return collectionViewSize
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        performSegueWithIdentifier("showDetail", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let imageDetailViewController = segue.destinationViewController as? ImageDetailUIViewController{
                imageDetailViewController.image = images[selectedIndex!]
                imageDetailViewController.timeStamp = assetManager.getTimeStamp(selectedIndex!)
               
            }
        }
    }
    
    // Opet dialog for URL insertion
    func insertUrl(){
         performSegueWithIdentifier("downloadImage", sender: self)
    }
 


}

