//
//  ViewPhoto.swift
//  PhotoGalleryDemo
//
//  Created by sanjeet on 9/5/16.
//  Copyright © 2016 sanjeet. All rights reserved.
//

import UIKit
import Photos
import SKPhotoBrowser
class ViewPhoto: UIViewController,SKPhotoBrowserDelegate
{
    
    var assetCollection:PHAssetCollection!
    var photosAsset:PHFetchResult!
    var index:Int = 0
    @IBOutlet var imgView: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.displayPhoto()

    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.hidesBarsOnTap = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func btnCancel(sender: AnyObject)
    {
        //self.navigationController?.popToRootViewControllerAnimated(false)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func btnExport(sender: AnyObject)
    {
        
        print("Export")
        let objectsToShare:UIImage = self.imgView.image!
        let activityViewController = UIActivityViewController(activityItems : [objectsToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityTypeAirDrop, UIActivityTypePostToFacebook,UIActivityTypePostToTwitter]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTrash(sender: AnyObject)
    {
        
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure want to delete this image?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (alertAction) in
            
            //Delete Photo
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ 
                
                let request = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
                request?.removeAssets([self.photosAsset[self.index]])
                }, completionHandler: { (success, Error) in
                    NSLog("\nDeleted Image ->%@", (success ? "Success" : "Error!"))
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
                    if self.photosAsset.count == 0{
                        //no photos left
                        self.imgView.image = nil
                        print("No Images left!")
                    }
                    if self.index >= self.photosAsset.count{
                        
                        self.index = self.photosAsset.count - 1
                    }
                    self.displayPhoto()
            })
        }))
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (alertAction) in
            
            //Don't Delete Photo
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func displayPhoto()
    {
        let imageManager =  PHImageManager.defaultManager()
        if self.photosAsset == nil {
            return
        }
        let ID = imageManager.requestImageForAsset(self.photosAsset[self.index] as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler:{(result,info)in
            self.imgView.image = result
        })
    }
    
}
