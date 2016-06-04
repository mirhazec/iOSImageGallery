//
//  ImageDetailUIViewController.swift
//  iOSImageGallery
//
//  Created by Mirha Zec on 6/4/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import UIKit
import Charts

class ImageDetailUIViewController: UIViewController,ChartViewDelegate {
    
  
    @IBOutlet weak var histogram: BarChartView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image:UIImage?
    var timeStamp:NSDate?
    var grayscaleImage:UIImage?
    var negativeImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = image
        self.title = DateUtilities.sharedInstance.getTimeLocalized(timeStamp!)
        self.histogram.delegate = self
        self.histogram.noDataText = "Creating histogram, please wait ..."
    
    }

    @IBAction func createNegative(sender: AnyObject) {
        self.histogram.hidden = true
        if(self.negativeImage == nil) {
            self.negativeImage = ImageManager().getNegativeImage(image!)
        }
        self.imageView.image = negativeImage
    }
    
    @IBAction func originalImageShow(sender: AnyObject) {
        self.histogram.hidden = true
        self.imageView.image = image
    }
    
    @IBAction func grayScaleImageShow(sender: AnyObject) {
        if(self.grayscaleImage == nil) {
             self.grayscaleImage = ImageManager().getGrayscaleImage(image!)
        }
        self.histogram.hidden = true
        self.imageView.image = grayscaleImage
    }
    
    @IBAction func showHistogram(sender: AnyObject) {
    
        self.histogram.hidden = false
        var array = [Double]()
        for y in 0..<255 {
            array.append(Double(y))
        }
        if(histogram.data == nil){
            dispatch_async(dispatch_get_main_queue(), {
                self.setChartData(array,valuesRed: ImageManager().getRedHistogram(self.image!),valuesGreen: ImageManager().getGreenHistogram(self.image!),valuesBlue: ImageManager().getBlueHistogram(self.image!))
            })
        }
        
    }
    

    func setChartData(dataPoints: [Double], valuesRed: [Double],valuesGreen:[Double],valuesBlue:[Double]) {
  
        var yVals1 : [BarChartDataEntry] = [BarChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        var yVals3 : [BarChartDataEntry] = [BarChartDataEntry]()
        for  i  in  0..<dataPoints.count {
            yVals1.append(BarChartDataEntry(value: valuesRed[i], xIndex: i))
        }
        
        for  i  in  0..<dataPoints.count {
            yVals2.append(BarChartDataEntry(value: valuesGreen[i], xIndex: i))
        }
        for  i  in  0..<dataPoints.count {
            yVals3.append(BarChartDataEntry(value: valuesBlue[i], xIndex: i))
        }
        var array = [String]()
        for y in 0..<255 {
            array.append(String(y))
        }
        
        //create a data set with array
        let set1: BarChartDataSet = BarChartDataSet(yVals: yVals1, label: "Red")
        set1.colors = [UIColor.redColor()]
        
        let set2: BarChartDataSet = BarChartDataSet(yVals: yVals2, label: "Green")
        set2.colors = [UIColor.greenColor()]
        
        let set3: BarChartDataSet = BarChartDataSet(yVals: yVals3, label: "Blue")
        set3.colors = [UIColor.blueColor()]
        
      
        var dataSets : [BarChartDataSet] = [BarChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
     
       
        let data: BarChartData = BarChartData(xVals: array , dataSets: dataSets)

        data.setValueTextColor(UIColor.whiteColor())
        
  
        self.histogram.data = data
        
    }
}
