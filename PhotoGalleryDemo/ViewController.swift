//
//  ViewController.swift
//  PhotoGalleryDemo
//
//  Created by sanjeet on 9/5/16.
//  Copyright © 2016 sanjeet. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AVKit
import MobileCoreServices
import SKPhotoBrowser
class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SKPhotoBrowserDelegate{

    var albumName = "My App"
    var assetCollection:PHAssetCollection!
    var photosAsset:PHFetchResult!
    var albumFound:Bool = false
    var count:Int = 0
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var originImage: UIImage!
    var localArray = [NSURL]()
    var PhotoArray = [UIImage]()
    var images = [SKPhoto]()
    @IBOutlet weak var moreLable: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor.whiteColor()
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@",albumName)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        if collection.firstObject != nil
        {
            self.albumFound = true
            self.assetCollection = collection.firstObject as! PHAssetCollection
        }
        else
        {
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.albumName)
                },
                completionHandler: {(success, error)in
                 NSLog("Creation of folder ->%@", (success ? "Success" : "Error!"))
                 self.albumFound = (success ? true : false)
            })
        }
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.captionFont = UIFont(name: "Helvetica", size: 18.0)!
        SKPhotoBrowserOptions.disableVerticalSwipe = true 
        self.collectionView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.hidesBarsOnTap = false
        self.PhotoArray.removeAll()
        self.images.removeAll()
        if self.assetCollection != nil {
            self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
            photosAsset.enumerateObjectsUsingBlock { (object:AnyObject, count:Int, stop:UnsafeMutablePointer<ObjCBool>) in
                if object is PHAsset{
                    let asset = object as! PHAsset
                    let imageSize = CGSize(width: asset.pixelWidth,height: asset.pixelHeight)
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .FastFormat
                    options.synchronous = true
                    PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: .AspectFit, options: options, resultHandler: { (image, info) in
                        self.PhotoArray.append(image!)
                        if asset.mediaType == .Image {
                            let photo = SKPhoto.photoWithImage(image!)
                            photo.caption = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
                            self.images.append(photo)
                        }
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }

    @IBAction func btnCamera(sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            let  picker:UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (alertAction) in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func btnPhotoAlbum(sender: AnyObject)
    {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectVideo(sender: AnyObject)
    {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as NSString as String ]
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.photosAsset != nil
        {
            count = self.PhotoArray.count
            if self.PhotoArray.count > 6{
                return 6
            }else{
            
                return count
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell : PhotoThumbNail = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoThumbNail
        
        for item in cell.subviews {
            
            if item.isKindOfClass(UIImageView)
            {
                let img = item as? UIImageView
                img?.image = nil
            }
        }
        if indexPath.item <= 4
        {
          cell.moreLable.hidden = true
        }
        else
        {
            cell.moreLable.textColor = UIColor.whiteColor()
            cell.moreLable.font = UIFont.boldSystemFontOfSize(25)
            cell.moreLable.text = "+" + " " + String(count-indexPath.item-1)
            cell.moreLable.hidden = false
        }
        
        let asset : PHAsset = self.photosAsset[indexPath.item] as! PHAsset
        cell.setThumbnailImage(self.PhotoArray[indexPath.item])
        
        /*PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler: {(result, info)in
            cell.setThumbnailImage(result!)
        })*/
        if indexPath.item < self.localArray.count && self.localArray.count != 0
        {
            self.localArray[indexPath.item] = NSURL.fileURLWithPath("abc")
        }
        else
        {
            self.localArray.append(NSURL.fileURLWithPath("abc"))
        }
        if asset.mediaType == .Image {
            cell.PlayerButton.hidden = true
        }
        else if asset.mediaType == .Video
        {
            cell.PlayerButton.hidden = false
            cell.PlayerButton.tag = indexPath.item
            cell.PlayerButton.addTarget(self, action: #selector(ViewController.btnPlayVedio), forControlEvents: .TouchUpInside)
            cell.PlayerButton.setImage(UIImage(named: "play.png"), forState: .Normal)
            PHImageManager.defaultManager().requestAVAssetForVideo(asset, options: nil, resultHandler: { (avAsset, audioMix, info) in
                if let urlAsset : AVURLAsset = avAsset as? AVURLAsset {
                    let localVideoUrl : NSURL = urlAsset.URL
                    if indexPath.item < self.localArray.count && self.localArray.count != 0
                    {
                        self.localArray[indexPath.item] = localVideoUrl
                    }
                    else
                    {
                        self.localArray.append(localVideoUrl)
                    }
                }
            })
        }
        return cell
    }
    
    func btnPlayVedio(sender : AnyObject){
        let localVideoUrl : NSURL = self.localArray[sender.tag]
        let player = AVPlayer(URL : localVideoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true){
            playerViewController.player!.play()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let asset : PHAsset = self.photosAsset[indexPath.item] as! PHAsset
        if  asset.mediaType == .Video {
            let localVideoUrl : NSURL = self.localArray[indexPath.item]
            let player = AVPlayer(URL : localVideoUrl)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.presentViewController(playerViewController, animated: true){
                playerViewController.player!.play()
            }
        }
        else if asset.mediaType == .Image
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoThumbNail
            let originImage = cell.imgView.image //self.PhotoArray[indexPath.item]
            
            let browser = SKPhotoBrowser(originImage: originImage!, photos: images, animatedFromView: cell)
            browser.initializePageIndex(indexPath.row-1)
            presentViewController(browser, animated: true, completion: {})
           //self.performSegueWithIdentifier("viewLargePhoto", sender:indexPath)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "viewLargePhoto"{
            let controller:ViewPhoto = segue.destinationViewController as! ViewPhoto
            let indexPath = sender as! NSIndexPath
            controller.index = indexPath.item
            controller.photosAsset = self.photosAsset
            controller.assetCollection = self.assetCollection
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqualToString(kUTTypeImage as NSString as String){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
                albumChangeRequest!.addAssets([assetPlaceholder!])
                }, completionHandler: {(success, Error)in
                    NSLog("Adding image to Library ->%@", (success ? "Success" : "Error!"))
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSelector(#selector(ViewController.reloadCollectionData), withObject: nil, afterDelay:0.01)
                    })
                    picker.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        else if mediaType.isEqualToString(kUTTypeMovie as NSString as String) || mediaType.isEqualToString(kUTTypeVideo as NSString as String){
            let videoPath = info[UIImagePickerControllerMediaURL] as! NSURL
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(videoPath)
                let assetPlaceholder = createAssetRequest?.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
                albumChangeRequest!.addAssets([assetPlaceholder!])
                }, completionHandler: { (success, error) in
                    NSLog("Adding video to Library ->%@", (success ? "Success" : "Error"))
                    picker.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
   func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
   }
    
   func reloadCollectionData(){
    
        self.collectionView.reloadData()
    }
}

