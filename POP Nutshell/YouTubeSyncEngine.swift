//
//  YouTubeSyncEngine.swift
//  POP Nutshell
//
//  Created by Patrick Bellot and collaborated with Andy Bargh https://www.andybargh.com on 6/30/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//


import CoreData
import Foundation
import SwiftyJSON

class YouTubeSyncEngine {
    
    let context: NSManagedObjectContext
    let service: YouTubeService
    
    init(context: NSManagedObjectContext, service: YouTubeService) {
        self.context = context
        self.service = service
    }
    
    /**
     Causes the Sync Engine to fetch the data from youtube.
     */
    func sync() {
        service.fetchData(completionHandler: processData)
    }
    
    /**
     Used to process data retrieved by the YouTubeService. That
     data is processed on a background queue (PrivateQueueConcurrencyType) to
     ensure the the UI isn't blocked.
     
     - parameter result: A JSON blob containing the video data retrieved by the
     YouTube service.
     */
    func processData(result: Result<JSON>) {
        
        // Ensure that the data was retrieved successfully.
        guard case let .Success(jsonData) = result else {
            // If it wasn't, there won't be anything to process.  We've already
            // printed the error in the Service code.
            return
        }
        
        // Create Background Managed Object Context
        let privateContext = NSManagedObjectContext(
            concurrencyType: .PrivateQueueConcurrencyType)
        
        // Give the background context the same persistent store coordinator
        privateContext.persistentStoreCoordinator =
            self.context.persistentStoreCoordinator
        
        
        // Process the received data using the background context.
        privateContext.performBlock { () -> Void in
            
            // NOTE: All this will be executed on a background queue.  This
            // means no updating the UI.  If the UI needs to be udpated then
            // need to dispatch_async back to the main queue.
            
            // Objective: Process the receieved data back and insert it into
            // the Core Data Database.
            
            // For each of the received videos
            for (_, item) in jsonData["items"] {
                
                // Extract the id element.
                guard let id = item["id"].string else {
                    continue
                }
                
                // Retrieve the existing video or create a new one.
                let video = Video.with(id, isShared: false, inContext: privateContext) ??
                    Video(data: item, context: privateContext)
                
                print("Video: \(video)")
                
            }
            
            // Save the context.
            if privateContext.hasChanges {
                do {
                    try privateContext.save()
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            // Dispatch back to the main queue to update the UI or maybe
            // trigger some sort of callback.
            //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //
            //            })
        }
    } // Closing brace for processData()
}
