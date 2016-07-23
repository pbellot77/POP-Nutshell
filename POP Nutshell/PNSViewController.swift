//
//  PNSViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot, inspired by CodeWithChris https://www.youtube.com/playlist?list=PLMRqhzcHGw1aLoz4pM_Mg2TewmJcMg9uaon 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

private let cellIdentifier = "VideoCell"

class PNSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var coreDataStack: CoreDataStack!
    var fetchRequest: NSFetchRequest!
    var context: NSManagedObjectContext!
    var selectedVideo: Video!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let videoFetchRequest = NSFetchRequest(entityName: "Video")
        let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        let publishedSortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: true)
        let iDSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let thumbnailSortDescriptor = NSSortDescriptor(key: "thumbnails", ascending: false)
        videoFetchRequest.sortDescriptors = [titleSortDescriptor,
                                             publishedSortDescriptor,
                                             iDSortDescriptor,
                                             thumbnailSortDescriptor]
            
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
        } catch {
            print("An error occured")
        }
    }

    func configureCell(cell: VideoCell, indexPath: NSIndexPath){
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as! Video
        cell.titleLabel!.text = video.title
        
        let url = NSURL(string: (video.thumbnails?.url)!)
        if let imageData = NSData(contentsOfURL: url!) {
            cell.thumbnailUrl.image = UIImage(data: imageData)
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
            sharedVideo.isShared = true
            
            let activityViewController = UIActivityViewController(activityItems: [sharedVideo], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
            
            tableView.setEditing(false, animated: true)
        }
        shareButton.backgroundColor = UIColor.lightGrayColor()
        
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
