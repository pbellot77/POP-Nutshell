//
//  FavoritesTableViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/14/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData



class FavoritesTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private let favoritesCellIndentifier = "FavoriteCell"
    private let favoritesManager = FavoritesManager.sharedInstance
    
    override func viewDidLoad() {
        self.favoritesTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
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
        
        // Get the label for the cell
        let label = cell.viewWithTag(3) as! UILabel
        label.text = favoritedVideo.videoTitle
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
        
}// End of Class
