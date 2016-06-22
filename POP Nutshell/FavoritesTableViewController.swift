//
//  FavoritesTableViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/14/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private let favoritesCellIndentifier = "FavoriteCell"
    private let favoritesManager = FavoritesManager.sharedInstance
    var currentVideo: Video!
    
    override func viewDidLoad() {
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.delegate = self
        
        favoritesTableView.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(favoritesCellIndentifier)!
        let favoritedVideo = favoritesManager.getAllFavoritedVideos()[indexPath.row]
        cell.textLabel?.text = favoritedVideo.videoTitle
        // Need to add thumbnail
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {

            favoritesManager.deleteFavoritedVideo(currentVideo)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
        
}// End of Class
