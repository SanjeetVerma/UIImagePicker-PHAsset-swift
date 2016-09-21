//
//  PhotoThumbNail.swift
//  PhotoGalleryDemo
//
//  Created by sanjeet on 9/6/16.
//  Copyright © 2016 sanjeet. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class PhotoThumbNail: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var PlayerButton: UIButton!
    @IBOutlet weak var moreLable: UILabel!
    
    func setThumbnailImage(thumbnailImage:UIImage){
        
        self.imgView.image = thumbnailImage
    }
    static func generateThumbImage(url : NSURL) -> UIImage
    {
        /*var frameImg:UIImage? = nil
        let asset : AVAsset = AVAsset(URL: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset:asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMake(1, 30)
        do {
            let img :CGImageRef = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
            frameImg = UIImage(CGImage: img)
        } catch {
            print("Something went wrong")
        }
        return frameImg!*/
        
        var thumbImage: UIImage!
        let asset = AVAsset(URL: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(asset.duration.value / 3, asset.duration.timescale)
        if let cgImage = try? assetImgGenerate.copyCGImageAtTime(time, actualTime: nil) {
        thumbImage = UIImage(CGImage: cgImage)
        }
        return thumbImage
    }
}
