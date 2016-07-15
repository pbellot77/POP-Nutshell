//
//  PNSViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot, inspired by CodeWithChris https://www.youtube.com/playlist?list=PLMRqhzcHGw1aLoz4pM_Mg2TewmJcMg9uaon 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

/* PNSViewController should get the objects from core data, display the videos in the PNSVideoDetailViewController, and add favorites to the FavoritesTableViewController */

private let cellIdentifier = "VideoCell"
private let sharedInstance = CoreDataStack()

class PNSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedVideo: Video?
 
    var fetchedResultsController: NSFetchedResultsController!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSManagedObject)
        
        let fetchRequest = NSFetchRequest(entityName: "Video")
        let videoIdSort = NSSortDescriptor(key: "videoId", ascending: false)
        let videoTitleSort = NSSortDescriptor(key: "videoTitle", ascending: false)
        let videoThumbnailSort = NSSortDescriptor(key: "videoThumbnailUrl", ascending: false)
        let videoDescriptionSort = NSSortDescriptor(key: "videoDescription", ascending: false)
        
        fetchRequest.sortDescriptors = [videoIdSort, videoTitleSort, videoThumbnailSort, videoDescriptionSort]
        
        let moc = sharedInstance.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
                
        fetchedResultsController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        dataReady()
    }
    
    func configureCell(cell: VideoCell, indexPath: NSIndexPath){
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as! Video
        cell.titleLabel!.text = video.valueForKey("videoTitle") as? String
        let videoId = video.valueForKey("videoId") as? String
        
        let imageURL = NSURL(string: "https://i.ytimg.com/vi/" + videoId! + "/hqdefault.jpg")
        if let imageData = NSData(contentsOfURL: imageURL!) {
            cell.videoThumbnailUrl!.image = UIImage(data: imageData)
        }
    
        cell.textLabel?.backgroundColor = UIColor.darkGrayColor()
    }

    // Tableview Delegate methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Get the width of the screen to calculate the height of the row
        return (self.view.frame.size.width / 480) * 360
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultsController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! VideoCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let favoriteButton = UITableViewRowAction(style: .Normal, title: "Add to Favorites") { action, index in
            print("favorite button tapped")
            let video = self.fetchedResultsController.objectAtIndexPath(indexPath)
            
            let favoritedVideo = FavoritesManager.sharedInstance.createVideoFavorite()
            favoritedVideo.videoDescription = video.videoDescription
            favoritedVideo.id = video.videoId
            favoritedVideo.thumbnail = video.videoThumbnailUrl
            favoritedVideo.videoTitle = video.videoTitle
            
            let alert = UIAlertController(title: "Saved", message: "Video added to Favorites", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in })
            alert.addAction(okAction)
                
            self.presentViewController(alert, animated: true, completion: nil)
    
            self.coreDataStack.saveContext()
            tableView.setEditing(false, animated: true)
    }
        favoriteButton.backgroundColor = UIColor.blueColor()
        
        let shareButton = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
            
            let shareItem = self.fetchedResultsController.objectAtIndexPath(indexPath)
            
            let sharedVideo = FavoritesManager.sharedInstance.createVideoFavorite()
            sharedVideo.videoId = shareItem.videoId
            sharedVideo.videoThumbnailUrl = shareItem.videoThumbnailUrl
            sharedVideo.videoTitle = shareItem.videoTitle
            
            let activityViewController = UIActivityViewController(activityItems: [sharedVideo], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
            tableView.setEditing(false, animated: true)
        }
        shareButton.backgroundColor = UIColor.lightGrayColor()
        
        return [favoriteButton, shareButton]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Take note of which video the user selected
        let selectedVideo = fetchedResultsController.objectAtIndexPath(indexPath)
        // Call the segue
        performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the reference to the destination view controller
        let detailViewController = segue.destinationViewController as! PNSVideoDetailViewController
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
}

extension PNSViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            case .Update:
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! VideoCell
                configureCell(cell, indexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let indexSet = NSIndexSet(index: sectionIndex)
        switch type {
            case .Insert:
                tableView.insertSections(indexSet, withRowAnimation: .Automatic)
            case .Delete:
                tableView.deleteSections(indexSet, withRowAnimation: .Automatic)
        default :
            break
        }
    }
}
