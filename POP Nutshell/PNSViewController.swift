//
//  PNSViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import Alamofire

class PNSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = [Video]()
    var selectedVideo: Video?
    let model: VideoModel = VideoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.model.delegate = self
        
        // Fire off request to get videos
        model.getFeedVideos()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -VideoModel Delegate Methods
    func dataReady() {
        
        // Access the video objects that have been dowloaded
        self.videos = self.model.videoArray
        
        // Tell the tableVies to reload
        self.tableView.reloadData()
    }
    
    // Tableview Delegate methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Get the width of the screen to calculate the height of the row
        return self.view.frame.size.width
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
        let videoTitle = videos[indexPath.row].videoTitle
        
        // Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        // Customize the cell to display the video title
        cell.textLabel?.text = videoTitle
        
        // Construct the video thumbnail url
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
        
        // Create an NSURL object
        let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString)
        
        if videoThumbnailUrl != nil {
            
            // Create an NSURLRequest object
            let request = NSURLRequest(URL: videoThumbnailUrl!)
            
            // Create NSURLSession
            let session = NSURLSession.sharedSession()
            
            // Create a datatask and pass in the request
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                // Get a reference to the image view element of the cell
                let imageView = cell.viewWithTag(1) as! UIImageView
                
                // Create an image object from the data and assign it into the imageview
                imageView.image = UIImage(data: data!)
                    
                })
            })
            
            dataTask.resume()

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Take note of which video the user selected
        self.selectedVideo = self.videos[indexPath.row]
        
        // Call the segue
        self.performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the reference to the destination view controller
        let detailViewController = segue.destinationViewController as! PNSVideoDetailViewController
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }


} // End of Class

