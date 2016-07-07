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

class FavoritesManager: NSObject, NSFetchedResultsControllerDelegate {
    
    var coreDataStack = CoreDataStack.sharedInstance
    var fetchedResultsController: NSFetchedResultsController
    
    func initializeFetchedResultsController(){
        let favoriteRequest = NSFetchRequest(entityName: "Video")
        let favoriteTitleSort = NSSortDescriptor(key: "videoTitle", ascending: false)
        let favoriteIdSort = NSSortDescriptor(key: "videoId", ascending: false)
        let favoriteDescriptionSort = NSSortDescriptor(key: "videoDescription", ascending: false)
        let favoriteThumbnailSort = NSSortDescriptor(key: "videoThumbnailUrl", ascending: false)
        favoriteRequest.sortDescriptors = [favoriteTitleSort, favoriteIdSort, favoriteDescriptionSort, favoriteThumbnailSort]
        
        let moc = self.coreDataStack.context
        fetchedResultsController = NSFetchedResultsController(fetchRequest: favoriteRequest, managedObjectContext: moc, sectionNameKeyPath: "videoId", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
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
    
    class var sharedInstance: FavoritesManager {
        struct Singleton {
            static let instance: FavoritesManager = FavoritesManager()
        }
        return Singleton.instance
    }
}// End of Class