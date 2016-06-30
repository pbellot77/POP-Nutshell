//
//  FavoritesManager.swift
//  POP Nutshell
//
//  Created by Patrick Bellot & Thomas Hanning http://www.twitter.com/@hanning_thomas on 6/17/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//
import Foundation
import CoreData

class FavoritesManager: NSObject {
    
    var coreDataStack = CoreDataStack.sharedInstance
        
    class var sharedInstance: FavoritesManager {
        struct Static {
            static let instance: FavoritesManager = FavoritesManager()
        }
        return Static.instance
    }
    
    //MARK: - Insert
    func insertEntityForName(entityName: String) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: coreDataStack.context)
    }
    
    //MARK: - Delete
    func deleteFavoritedVideo(video: Video) {
        coreDataStack.context.deleteObject(video)
    }
    
    //MARK: - Get video
    func getAllFavoritedVideos() -> [Video] {
        return try! coreDataStack.context.executeFetchRequest(NSFetchRequest(entityName: "Video")) as! [Video] 
    }
    
    //MARK: - Create a favorite video
    func createVideoFavorite() -> Video {
        coreDataStack.saveContext()
        return insertEntityForName("Video") as! Video
    }
}// End of Class