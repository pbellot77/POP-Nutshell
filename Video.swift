//
//  Video.swift
//  
//
//  Created by Patrick Bellot on 7/15/16.
//
//

import Foundation
import CoreData
import SwiftyJSON


class Video: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    /**
     Used to search for a video with a given YouTube ID.
     
     - parameter id:      The unique YouTube id for the video.
     - parameter context: The managed object context in which to perform the
     search.
     
     - returns: The Video object with the given id or nil otherwise.
     */
    
    static func with(id: String, title: String, inContext context: NSManagedObjectContext) -> Video? {
        
        let entityDescription = NSEntityDescription.entityForName(
            "Video", inManagedObjectContext: context)!
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entityDescription
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1 // Limit it to a max of 1 result. (Should only ever be one)
        
        do {
            let videos = try context.executeFetchRequest(fetchRequest) as! [Video]
            return videos.first
            
        } catch let error as NSError {
            print("Error searching for channel: \(error), \(error.userInfo)")
            return nil
        }
    }
    
    /**
     A convenience initiailser that allows a Video object to be created from
     a JSON blob retrieved via the YouTubeService.
     
     - parameter data:    The raw JSON data.
     - parameter context: The managed object context within which to create the
     new object.
     
     - returns: A Video object initialised from the supplied JSON data.
     */
    convenience init(data: JSON, context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName(
            "Video", inManagedObjectContext: context)!
        
        self.init(entity: entityDescription,
                  insertIntoManagedObjectContext: context)
        
        // Extract general video information.
        self.id = data["id"].string
        let snippet = data["snippet"]
        self.title = snippet["title"].string
        self.videoDescription = snippet["description"].string
        self.videoId = snippet["resourceId","videoId"].string
        
        // Extract the publishedAt date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let jsonDateString = snippet["publishedAt"].string
        if let jsonDateString = jsonDateString {
            let date = dateFormatter.dateFromString(jsonDateString)
            self.publishedAt = date
        }
        
        // Create associated thumbnails
        let jsonThumbnails = snippet["thumbnails"]
        let thumbnails = NSMutableSet()
        for thumbnail in jsonThumbnails {
            
            let (size, data) = thumbnail
            let width = data["width", 480].count
            let height = data["height", 360].count
            let rawURL = data["high","url"].string
            let high = data["high","url"].string
            
            
            let thumbnail = Thumbnail(size: size, width: width,
                                      height: height, rawURL: rawURL, high: high,
                                     video: self, inContext: context)
            thumbnails.addObject(thumbnail)
            self.thumbnails = thumbnail // Throws compiler error outside of scope
        }
       
        
        // Fetch and associate or create and associated a channel
        if let channelId = snippet["channelId"].string,
            channelTitle = snippet["channelTitle"].string {
            
            let channel = Channel.with(channelId, inContext: context) ??
                Channel(id: channelId, title: channelTitle, context: context)
            self.channel = channel
        }
    }
}