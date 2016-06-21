//
//  FavoritesManager.swift
//  POP Nutshell
//
//  Created by Patrick Bellot & Thomas Hanning http://www.twitter.com/@hanning_thomas on 6/17/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class FavoritesManager: NSObject, UITableViewDataSource {
    
    let favoritesCellIndentifier = "FavoriteCell"
    var coreDataStack: CoreDataStack!
    var managedContext: NSManagedObjectContext!
    var favoriteVideos:[Video] = [Video]()
    var fetchRequest: NSFetchRequest!
    var videos: [Video]!
    
    
    class var sharedInstance: FavoritesManager {
        struct Static {
            static let instance: FavoritesManager = FavoritesManager()
        }
        return Static.instance
    }
    
    //MARK: - Insert
    func insertEntityForName(entityName: String) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedContext)
    }
    
    //MARK: - Fetch
    func fetchEntitiesForName(entityName: String) -> NSArray{
        
        //let model = coreDataStack.context.persistentStoreCoordinator!.managedObjectModel
        //fetchRequest = model.fetchRequestTemplateForName("FetchRequest")
        fetchRequest = NSFetchRequest(entityName: "Video")
        fetchAndReload()
        
        return videos
    }
    
    //MARK: - Fetch Helper Methods
    func fetchAndReload() {
        
        do{
            videos = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Video]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Delete
    func deleteFavoritedVideo(video: Video) {
        self.managedContext.deleteObject(video)
    }
    
    //MARK: - Get video
    func getAllFavoritedVideos() -> [Video] {
        
        return favoriteVideos
    }
    
    //MARK: - Create a favorite video
    func createVideoFavorite() -> Video {
        do {
        try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
        return Video()
    }
    
    //MARK: - FavoritesTableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteVideos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(favoritesCellIndentifier)!
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}// End of Class