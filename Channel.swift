//
//  Channel.swift
//  
//
//  Created by Patrick Bellot on 7/15/16 and collaborated with Andy Bargh https://www.andybargh.com.
//
//

import Foundation
import CoreData


class Channel: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    /**
     A convenience function that allows a Channel with a given ChannelId to be
     retrieved.
     
     - parameter id:      The unique YouTube identifier for the channel.
     - parameter context: The managed object context on which to execute the
     core data queries.
     
     - returns: The Channel object matching the given id if found or nil otherwise.
     */
    static func with(id: String, inContext context: NSManagedObjectContext) -> Channel? {
        
        let entityDescription = NSEntityDescription.entityForName(
            "Channel", inManagedObjectContext: context)!
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entityDescription
        let predicate = NSPredicate(format: "channelId == %@", id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let channels = try context.executeFetchRequest(fetchRequest) as! [Channel]
            return channels.first
            
        } catch let error as NSError {
            print("Error searching for channel: \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    /**
     Convenience initialiser that allows a Channel to be created within a given
     context from a unique identifier and optional title.
     
     - parameter id:      The unique YouTube identifier for the channel
     - parameter title:   The channel title
     - parameter context: The managed object context to use to create the object.
     
     - returns: A Channel Object with the supplied id and title.
     */
    convenience init(id: String, title: String?, context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entityForName(
            "Channel", inManagedObjectContext: context)!
        
        self.init(entity: entityDescription,
                  insertIntoManagedObjectContext: context)
        
        self.channelId = id
        self.channelTitle = title
    }

}
