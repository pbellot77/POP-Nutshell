//
//  FavoritesTableViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot and Thomas Hanning http://www.thomasHanning.com on 6/14/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private let favoritesCellIndentifier = "FavoriteCell"
    private let favoritesManager = FavoritesManager.sharedInstance
    var currentVideo: Video!
    var favData: Array<Video> = []
    
    override func viewDidLoad() {
        self.favoritesTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        favoritesManager.getAllFavoritedVideos()
        favoritesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - FavoritesTableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesManager.getAllFavoritedVideos().count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.view.frame.size.width / 480) * 360
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(favoritesCellIndentifier)!
        let favoritedVideo = favoritesManager.getAllFavoritedVideos()[indexPath.row]
        favData.append(favoritedVideo)
        
        let videoTitle = favoritedVideo.videoTitle
        let label = cell.viewWithTag(3) as! UILabel
        label.text = videoTitle
        
        // Add thumbnail
        let thumbnailString = "https://i.ytimg.com/vi/" + favoritedVideo.videoId! + "/hqdefault.jpg"
        if let videoThumbnailUrl = NSURL(string: thumbnailString) {
            let request = NSURLRequest(URL: videoThumbnailUrl)
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Get a reference to the image view element of the cell
                    let imageView = cell.viewWithTag(4) as! UIImageView
                    
                    // Create an image object from the data and assign it into the imageview
                    imageView.image = UIImage(data: data!)
                })
            })
            
            dataTask.resume()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let favoritesManager:FavoritesManager = FavoritesManager.sharedInstance
            let context:NSManagedObjectContext = favoritesManager.coreDataStack.context
            context.deleteObject(favData[indexPath.row])
            favData.removeAtIndex(indexPath.row)
            do {
                try context.save()
            } catch _ {
                
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            return 
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
}// End of Class
