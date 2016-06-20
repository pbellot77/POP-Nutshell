//
//  FavoritesTableViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/14/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private let favoritesManager = FavoritesManager()
    
    override func viewDidLoad() {

       favoritesTableView.dataSource = FavoritesManager()
        favoritesManager.getAllFavoritedVideos()
        favoritesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}// End of Class
