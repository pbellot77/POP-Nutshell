//
//  PNSViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot, inspired by CodeWithChris https://www.youtube.com/playlist?list=PLMRqhzcHGw1aLoz4pM_Mg2TewmJcMg9uaon 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import Alamofire

//TODO: Delete VideoModelDelegate by using NSFetchResultsControllerDelegate
class PNSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = [Video]()
    var selectedVideo: Video?
    let model: PNSClient = PNSClient()
    let coreDataStack = CoreDataStack.sharedInstance
    internal var context: CoreDataStack!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let videoFetchRequest = NSFetchRequest(entityName: "Video")
        let videoIDSortDescriptor = NSSortDescriptor(key: "videoId", ascending: true)
        let videoTitleSortDescriptor = NSSortDescriptor(key: "videoTitle", ascending: false)
        let videoDescriptionSortDescriptor = NSSortDescriptor(key: "videoDescription", ascending: false)
        let videoThumbnailSortDescriptor = NSSortDescriptor(key: "videoThumbnail", ascending: false)
        videoFetchRequest.sortDescriptors = [videoIDSortDescriptor, videoTitleSortDescriptor, videoDescriptionSortDescriptor, videoThumbnailSortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: videoFetchRequest, managedObjectContext: self.context, sectionNameForKeyPath: "", cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error occured during fetch")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Tableview Delegate methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Get the width of the screen to calculate the height of the row
        return (self.view.frame.size.width / 480) * 360
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath)
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as! Video
        let videoTitle = video.videoTitle
        let thumbnail = video.videoThumbnail
        
        // Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
    //TODO: Remove the networking from cellForRowAtIndexPath and add it to the client
        // Construct the video thumbnail url
        let videoThumbnailUrlString = "https://i.ytimg.com/vi/" + video.videoID + "/hqdefault.jpg"
        
        // Create an NSURL object
        if let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString) {
            
            // Create an NSURLRequest object
            let request = NSURLRequest(URL: videoThumbnailUrl)
            
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let favoriteButton = UITableViewRowAction(style: .Normal, title: "Add to Favorites") { action, index in
            print("favorite button tapped")
            
            let video = self.videos[indexPath.row]
            
            let favoritedVideo = DataHelper.sharedInstance.createVideoFavorite()
            favoritedVideo.videoDescription = video.videoDescription
            favoritedVideo.videoId = video.videoId
            favoritedVideo.videoThumbnail = video.videoThumbnail
            favoritedVideo.videoTitle = video.videoTitle
            
            let alert = UIAlertController(title: "Saved", message: "Video added to Favorites", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in })
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        favoriteButton.backgroundColor = UIColor.blueColor()
        
        let shareButton = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
            
            let shareItem = self.videos[indexPath.row]
            
            let sharedVideo = DataHelper.sharedInstance.createVideoFavorite()
            sharedVideo.videoId = shareItem.videoId
            sharedVideo.videoThumbnail = shareItem.videoThumbnail
            sharedVideo.videoTitle = shareItem.videoTitle
            
            let activityViewController = UIActivityViewController(activityItems: [sharedVideo], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        }
        shareButton.backgroundColor = UIColor.lightGrayColor()
        
        return [favoriteButton, shareButton]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Take note of which video the user selected
        selectedVideo = self.videos[indexPath.row]
        
        // Call the segue
        performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the reference to the destination view controller
        let detailViewController = segue.destinationViewController as! PNSVideoDetailViewController
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
} // End of Class

