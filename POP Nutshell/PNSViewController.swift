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
import ReachabilitySwift

private let cellIdentifier = "VideoCell"

class PNSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchRequest: NSFetchRequest!
    var selectedVideo: Video!
    var context: NSManagedObjectContext!
    var reachability: Reachability?
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let videoFetchRequest = NSFetchRequest(entityName: "Video")
        let publishedSortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: false)
        videoFetchRequest.sortDescriptors = [publishedSortDescriptor]
            
        let frc = NSFetchedResultsController(
            fetchRequest: videoFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
            
            frc.delegate = self
            
            return frc
        }()
    
        override func viewWillAppear(animated: Bool) {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PNSViewController.reachabilityChanged(_:)),
                                                                   name: ReachabilityChangedNotification,
                                                                 object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
            
            dispatch_async(dispatch_get_main_queue()) {
                print("Internet Unavailable")
                
                let alert = UIAlertController(title: "Internet Unavailable",
                                              message: "Try again when connected to the Internet",
                                              preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                    print("You selected OK")
                }
                
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        reachability.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification,
                                                                object: reachability)
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PNSViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
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
        tableView.addSubview(self.refreshControl)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        if reachability?.isReachable() == true {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                print("Internet Unavailable")
                
                let alert = UIAlertController(title: "Internet Unavailable", message: "Try refresh when internet is available", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                    print("OK selected")
            }
             
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                refreshControl.endRefreshing()
            }
        }
    }
    
    func configureCell(cell: VideoCell, indexPath: NSIndexPath){
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
        
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as! Video
        cell.titleLabel!.text = video.title
        
        
        // Construct the video thumbnail url
        guard let filteredThumbs = (video.thumbnails?.allObjects as? [Thumbnail])?.filter({$0.size == "high"}) else {
            // Potentially add default image...
            return
        }
        
        guard filteredThumbs.count > 0  else { return }
        
        let highThumb = filteredThumbs[0]
        guard let url = highThumb.url else { return }
        
        // Create an NSURL object
        if let videoThumbnailUrl = NSURL(string: url) {
            
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
            
            let sharedVideo = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Video
            let title = sharedVideo?.title
            let thumbnail = sharedVideo?.thumbnails?.allObjects as? [Thumbnail]
            
            let activityViewController = UIActivityViewController(activityItems: [title!, thumbnail!], applicationActivities: nil)
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
    
    // MARK: - FetchResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?,
                    forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {
        let ios9 = NSOperatingSystemVersion(majorVersion: 9, minorVersion: 0, patchVersion: 0)
        if NSProcessInfo().isOperatingSystemAtLeastVersion(ios9) == false { return }
        
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                print("")
                if let indexPath = indexPath {
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! VideoCell
                    configureCell(cell, indexPath: indexPath)
                }
            case .Move:
                if indexPath != newIndexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                    tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                }
            }
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                    atIndex sectionIndex: Int,
                    forChangeType type: NSFetchedResultsChangeType) {
        let ios9 = NSOperatingSystemVersion(majorVersion: 9, minorVersion: 0, patchVersion: 0)
        if NSProcessInfo().isOperatingSystemAtLeastVersion(ios9) == false { return }
        
        
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
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}