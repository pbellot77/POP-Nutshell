//
//  PNSViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot, inspired by CodeWithChris https://www.youtube.com/playlist?list=PLMRqhzcHGw1aLoz4pM_Mg2TewmJcMg9uaon 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

private let cellIdentifier = "VideoCell"

class PNSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchRequest: NSFetchRequest!
    var selectedVideo: Video!
    var context: NSManagedObjectContext!
    var service: YouTubeService!

    lazy var fetchedResultsController: NSFetchedResultsController = {
        let videoFetchRequest = NSFetchRequest(entityName: "Video")
        let publishedSortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: false)
        let idSortDescriptor = NSSortDescriptor(key: "videoId", ascending: false)
        let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        videoFetchRequest.sortDescriptors = [publishedSortDescriptor, idSortDescriptor, titleSortDescriptor]
            
        let frc = NSFetchedResultsController(
            fetchRequest: videoFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
            
            frc.delegate = self
            
            return frc
        }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.context = appDelegate.coreDataStack?.managedObjectContext
        
        print(NSManagedObject)
   
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func configureCell(cell: VideoCell, indexPath: NSIndexPath){
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as? Video
        cell.titleLabel!.text = video!.title
        
//        if let imageURL = NSURL(string: "https://i.ytimg.com/vi/" + video.videoId! + "/hqdefault.jpg"){
//          if let imageData = NSData(contentsOfURL: imageURL){
//              cell.thumbnailImage.image = UIImage(data: imageData)
//            }
//        }
        // Construct the video thumbnail url
        let videoThumbnailUrlString = "https://i.ytimg.com/vi/" + video!.videoId! + "/hqdefault.jpg"
        
        // Create an NSURL object
        if let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString) {
            
            // Create an NSURLRequest object
            let request = NSURLRequest(URL: videoThumbnailUrl)
            
            // Create NSURLSession
            let session = NSURLSession.sharedSession()
            
            // Create a datatask and pass in the request
            let dataTask = session.dataTaskWithRequest(request,
                                                        completionHandler: { (data: NSData?,
                                                        response: NSURLResponse?,
                                                        error: NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Get a reference to the image view element of the cell
                    let imageView = cell.thumbnailImage as UIImageView
                    
                    // Create an image object from the data and assign it into the imageview
                    imageView.image = UIImage(data: data!)
                })
            })
            
            dataTask.resume()
        }        
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
        
        let shareButton = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
            
            let sharedVideo = Video()
            
            let activityViewController = UIActivityViewController(activityItems: [sharedVideo], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
            tableView.setEditing(false, animated: true)
        }
        shareButton.backgroundColor = UIColor.blueColor()
        
        return [shareButton]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Take note of which video the user selected
        selectedVideo = fetchedResultsController.objectAtIndexPath(indexPath) as? Video
        // Call the segue
        performSegueWithIdentifier("goToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the reference to the destination view controller
        let detailViewController = segue.destinationViewController as! PNSVideoDetailViewController
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?,
                    forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {
        
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! VideoCell
                configureCell(cell, indexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                    atIndex sectionIndex: Int,
                    forChangeType type: NSFetchedResultsChangeType) {
        
        let indexSet = NSIndexSet(index: sectionIndex)
        switch type {
            case .Insert:
                tableView.insertSections(indexSet, withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteSections(indexSet, withRowAnimation: .Fade)
        default :
            break
        }
    }
}