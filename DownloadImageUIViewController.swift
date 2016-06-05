//
//  DownloadImageUIViewController.swift
//  iOSImageGallery
//
//  Created by Mirha Zec on 6/4/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import UIKit
import SystemConfiguration


class DownloadImageUIViewController: UIViewController,NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    
    var activeDownload:Download?
    var url : String?
    var savedUrl:NSURL?
    var downloadedImage:UIImage?
    var dataTask: NSURLSessionDataTask?
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
 
   
    
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("bgSessionConfiguration")
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.downloadsSession
        self.initView()
    }
    
    func initView(){
       
        if let download = activeDownload {
            progressView.progress = download.progress
            progressLabel.text = (download.isDownloading) ? "Downloading..." : "Paused"
            progressView.setProgress(0.0, animated: false)
        }
        
    }
    
    @IBAction func downloadImage(sender: AnyObject) {
        if(isConnectedToNetwork() == true) {
            if(self.urlTextField.text != nil){
                dispatch_async(dispatch_get_main_queue(), {
                    self.url = self.urlTextField.text
               
                    self.startDownload()
                 })
            }else {
                self.showAlertDialog("Error", msg: "Url filed cannot be emtpy", viewController: self)
            }
            }else {
                self.showAlertDialog("Error", msg: "You have no internet connection", viewController: self)
            }
        
    }
    
   
    func startDownload() {
        self.urlTextField.resignFirstResponder()
        self.progressView.hidden = false
        self.progressLabel.hidden = false
        if let url =  NSURL(string: self.url!) {
           
            let download = Download(url: self.url!)
         
            download.downloadTask = downloadsSession.downloadTaskWithURL(url)
       
            download.downloadTask!.resume()
        
            download.isDownloading = true
         
            activeDownload = download
            
        } else {
            self.showAlertDialog("Error", msg: "Please enter correct url", viewController: self)
        }
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler()
                })
            }
        }
    }
    
    // URL Session delegate functions
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
    
        if let originalURL = downloadTask.originalRequest?.URL?.absoluteString,
            destinationURL = localFilePathForUrl(originalURL) {
            
            print(destinationURL)
            
      
            let fileManager = NSFileManager.defaultManager()
            
            do {
                try fileManager.removeItemAtURL(destinationURL)
            } catch {
                
            }
            do {
                try fileManager.copyItemAtURL(location, toURL: destinationURL)
                let data:NSData? = NSData(contentsOfURL : destinationURL)
                let image = UIImage(data : data!)
               
                
                 dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertDialog("Succes", msg: "Image saved", viewController: self)
                    self.imageView.image = image
                    self.imageView.hidden = false
                    self.progressView.setProgress(0.0, animated: true)
                })
                
                
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
                self.showAlertDialog("Error", msg: "Download failed,please try again later", viewController: self)
            }
            
        }
        
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        
        if let _ = downloadTask.originalRequest?.URL?.absoluteString,
            download = activeDownload {

            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
            let totalSize = NSByteCountFormatter.stringFromByteCount(totalBytesExpectedToWrite, countStyle: NSByteCountFormatterCountStyle.Binary)
            
                dispatch_async(dispatch_get_main_queue(), {
                    self.progressView.setProgress( download.progress, animated: true)
                    self.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
                })
            
        }
    }
    
    func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }
    

    func URLSession(session: NSURLSession,
                    task: NSURLSessionTask,
                    didCompleteWithError error: NSError?){
        self.activeDownload?.downloadTask = nil
        dispatch_async(dispatch_get_main_queue(), {
        self.progressView.setProgress(0.0, animated: true)
        if (error != nil) {
          
             self.showAlertDialog("Error", msg: "Please enter correct url", viewController: self)
        }else{
            print("The task finished transferring data successfully")

        }
        })
    }
    
    func showAlertDialog(title:String, msg:String, viewController:UIViewController?) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        if(viewController != nil) {
            viewController!.presentViewController(alertController, animated: true) { }
        }
    }
    
    
   
    deinit {
        self.downloadsSession.finishTasksAndInvalidate();
    }
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }


}

    
    

