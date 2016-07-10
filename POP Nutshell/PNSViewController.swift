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

private let cellIdentifier = "BasicCell"

class PNSViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = [Video]()
    var selectedVideo: Video?
    var coreDataStack: CoreDataStack!
    var context: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Video")
        let videoIdSort = NSSortDescriptor(key: "videoId", ascending: false)
        let videoTitleSort = NSSortDescriptor(key: "videoTitle", ascending: false)
        let videoThumbnailSort = NSSortDescriptor(key: "videoThumbnailUrl", ascending: false)
        let videoDescriptionSort = NSSortDescriptor(key: "videoDescription", ascending: false)
        
        fetchRequest.sortDescriptors = [videoIdSort, videoTitleSort, videoThumbnailSort, videoDescriptionSort]
        
        coreDataStack = CoreDataStack.sharedInstance
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: "videoId", cacheName: "pnsVideos")
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func configureCell(cell: VideoCell, indexPath: NSIndexPath){
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as! Video
        cell.videoThumbnailUrl!.image = UIImage(named: video.videoThumbnailUrl!)
        cell.titleLabel!.text = video.videoTitle
    }
}// End of Class

extension PNSViewController: UITableViewDataSource {

    // Tableview Delegate methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Get the width of the screen to calculate the height of the row
        return (self.view.frame.size.width / 480) * 360
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections!.count
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
            let video = self.videos[indexPath.row]
            
            let favoritedVideo = FavoritesManager.sharedInstance.createVideoFavorite()
            favoritedVideo.videoDescription = video.videoDescription
            favoritedVideo.videoId = video.videoId
            favoritedVideo.videoThumbnailUrl = video.videoThumbnailUrl
            favoritedVideo.videoTitle = video.videoTitle
            
            let alert = UIAlertController(title: "Saved", message: "Video added to Favorites", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in })
            alert.addAction(okAction)
            
            if video.isFavorite == true {
                
            self.presentViewController(alert, animated: true, completion: nil)
        }
            self.coreDataStack.saveContext()
            tableView.setEditing(false, animated: true)
    }
        favoriteButton.backgroundColor = UIColor.blueColor()
        
        let shareButton = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
            
            let shareItem = self.videos[indexPath.row]
            
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
}

extension PNSViewController: UITableViewDelegate {

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