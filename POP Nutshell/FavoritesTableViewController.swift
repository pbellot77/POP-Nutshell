//
//  FavoritesTableViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot and Thomas Hanning http://www.thomasHanning.com on 6/14/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

/* Only favorited videos should be pushed to the FavoritesTableViewController. Network requests for the thumbnail should be handled by the PNSClient.*/

private let cellIdentifier = "FavoriteCell"
private let favoritesManager = FavoritesManager.sharedInstance

class FavoritesTableViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    
    var favVideos: [Video] = [Video]()
    var currentVideo: Video?
    var favData: Array<Video> = []
    
    override func viewDidLoad() {
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        favoritesTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if favData.isEmpty{
            sendAlert()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCell(cell: FavoriteCell, indexPath: NSIndexPath){
        let video = favoritesManager.getAllFavoritedVideos()[indexPath.row]
        cell.videoThumbnailUrl!.image = UIImage(named: video.videoThumbnailUrl!)
        cell.titleLabel!.text = video.videoTitle
    }
}

extension FavoritesTableViewController: UITableViewDataSource {
    
    //MARK: - FavoritesTableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesManager.getAllFavoritedVideos().count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.view.frame.size.width / 480) * 360
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) 
        
        configureCell(FavoriteCell(), indexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let favoritesManager: FavoritesManager = FavoritesManager.sharedInstance
            let context:NSManagedObjectContext = favoritesManager.coreDataStack.managedObjectContext
            context.deleteObject(favData[indexPath.row])
            favData.removeAtIndex(indexPath.row)
            do {
                try context.save()
                sendAlert()
            } catch _ {
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            return 
        }
    }
}

extension FavoritesTableViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentVideo = favData[indexPath.row]
        performSegueWithIdentifier("toDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetail" {
            if let destinationVC = segue.destinationViewController as? FavoritesDetailViewController {
                destinationVC.currentVideo = self.currentVideo
            }
        }
    }
    
    func sendAlert() {
        let alert = UIAlertController(title: "No Favorites Added", message: "To Add Favorites Tap Home and Swipe Left", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { [weak self] (action) -> Void in
            self?.tabBarController?.selectedIndex = 0
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
    }
}// End of Class