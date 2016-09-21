//
//  CustomViewCell.swift
//  PhotoGalleryDemo
//
//  Created by sanjeet on 9/14/16.
//  Copyright © 2016 sanjeet. All rights reserved.
//

import UIKit

class CustomViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.SetupViews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func SetupViews(){
        
    }

}
