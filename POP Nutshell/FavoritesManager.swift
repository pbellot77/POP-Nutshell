//
//  FavoritesManager.swift
//  POP Nutshell
//
//  Created by Patrick Bellot & Thomas Hanning http://www.twitter.com/@hanning_thomas on 6/17/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//
import Foundation
import CoreData

/* This is where the favorites will be handled once added to favorites */

class FavoritesManager: NSObject {
    
    var coreDataStack = CoreDataStack()
    
    //MARK: - Insert
    private func insertEntityForName(entityName: String) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: coreDataStack.managedObjectContext)
    }
    
    //MARK: - Delete
    func deleteFavoritedVideo(video: Video) {
        coreDataStack.managedObjectContext.deleteObject(video)
    }
    
       //MARK: - Get video
    func getAllFavoritedVideos() -> [Video] {
        return try! coreDataStack.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Video")) as! [Video]
    }
    
    //MARK: - Create a favorite video
    func createVideoFavorite() -> Video {
        coreDataStack.saveContext()
        return insertEntityForName("Video") as! Video
    }
    
    class var sharedInstance: FavoritesManager {
        struct Singleton {
            static let instance: FavoritesManager = FavoritesManager()
        }
        return Singleton.instance
    }
}// End of Class