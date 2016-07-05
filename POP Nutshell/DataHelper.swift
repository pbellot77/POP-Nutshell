//
//  DataHelper.swift
//  POP Nutshell
//
//  Created by Patrick Bellot & Thomas Hanning http://www.twitter.com/@hanning_thomas on 6/17/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//
import Foundation
import CoreData

/* This is where the JSON will be handled. Formally Favorites Manager */

class DataHelper: NSObject {
    var coreDataStack = CoreDataStack.sharedInstance
    
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    internal func seedDataStore(){
        seedVideos()
    }
    
    private func seedVideos() {
        
        do {
            try context.save()
        } catch _{
        }
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
    
    class var sharedInstance: DataHelper {
        struct Singleton {
            static let instance: DataHelper = DataHelper()
        }
        return Singleton.instance
    }
}// End of Class