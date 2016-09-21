//
//  FacebookFeedViewView.swift
//  PhotoGalleryDemo
//
//  Created by sanjeet on 9/14/16.
//  Copyright © 2016 sanjeet. All rights reserved.
//
import UIKit

class FacebookFeedViewView: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var myData = ["Apple","Orange","Mango"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.topItem?.title = "Facebook Feed"
        
   
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(animated: Bool) {
        
       self.navigationController?.navigationBar.topItem?.title = "Facebook Feed"
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CustomViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)as! CustomViewCell
        
        cell.textLabel?.text = myData[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("PhotoSegue", sender: indexPath)
    }
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 500
    }*/

    
}
