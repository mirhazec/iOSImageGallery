//
//  PhotoEditingViewController.swift
//  iosImageFilters
//
//  Created by Mirha Zec on 6/5/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import UIKit
import Photos
import PhotosUI



class PhotoEditingViewController: UIViewController, PHContentEditingController {

    @IBOutlet weak var imageView: UIImageView!
    var input: PHContentEditingInput?
    var displayedImage: UIImage?
    var imageOrientation: Int32?
    var negativeFilter: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - PHContentEditingController

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        return false
    }

    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {

        input = contentEditingInput
        if input != nil {
            displayedImage = input!.displaySizeImage
            imageOrientation = input!.fullSizeImageOrientation
            imageView.image = displayedImage
        }
    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
            // Create editing output from the editing input.
            let output = PHContentEditingOutput(contentEditingInput: self.input!)
            
            let url = self.input?.fullSizeImageURL
            
            if let imageUrl = url {
                _ = UIImage(contentsOfFile:
                    imageUrl.path!)
                var resultImage = self.displayedImage
                if(self.negativeFilter == true){
                    resultImage = PhotoManager().getNegativeImage(self.displayedImage!)
                }else if (self.negativeFilter == false){
                    resultImage = PhotoManager().getGrayscaleImage(self.displayedImage!)
                }
                
                let renderedJPEGData =
                    UIImageJPEGRepresentation(resultImage!, 0.9)
                
                
                renderedJPEGData!.writeToURL(
                    output.renderedContentURL,
                    atomically: true)
                
                let archivedData =
                    NSKeyedArchiver.archivedDataWithRootObject(
                        "Negative")
                
                let adjustmentData =
                    PHAdjustmentData(formatIdentifier:
                        "test.ba.iOSImageGallery.iosImageFilters",
                                     formatVersion: "1.0",
                                     data: archivedData)
                
                output.adjustmentData = adjustmentData
            }
            completionHandler?(output)
            
            // Clean up temporary files, etc.
        }
    }

    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }

    func cancelContentEditing() {
       self.imageView.image = self.displayedImage
    }

    @IBAction func doNegative(sender: AnyObject) {
        self.negativeFilter = true
        self.imageView.image = PhotoManager().getNegativeImage(self.displayedImage!)
    }

    
    @IBAction func doGrayScale(sender: AnyObject) {
        self.negativeFilter = false
        self.imageView.image =  PhotoManager().getGrayscaleImage(self.displayedImage!)
        
        
    }
    
}
