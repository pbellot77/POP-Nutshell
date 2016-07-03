//
//  PNSViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot, inspired by CodeWithChris https://www.youtube.com/playlist?list=PLMRqhzcHGw1aLoz4pM_Mg2TewmJcMg9uaon 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

private let cellIdentifier = "BasicCell"

class PNSViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = [Video]()
    var selectedVideo: Video?
    let model: PNSClient = PNSClient()
    var coreDataStack: CoreDataStack!
    var context: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Video")
        let videoIdSort = NSSortDescriptor(key: "videoId", ascending: false)
        let videoTitleSort = NSSortDescriptor(key: "videoTitle", ascending: false)
        let videoThumbnailSort = NSSortDescriptor(key: "videoThumbnail", ascending: false)
        let videoDescriptionSort = NSSortDescriptor(key: "videoDescription", ascending: false)
        
        fetchRequest.sortDescriptors = [videoIdSort, videoTitleSort, videoThumbnailSort, videoDescriptionSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: "videoId", cacheName: "pnsVideos")
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func configureCell(cell: VideoCell, indexPath: NSIndexPath){
        
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

