//
//  Channel+CoreDataProperties.swift
//  
//
//  Created by Patrick Bellot on 7/15/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Channel {

    @NSManaged var channelTitle: String?
    @NSManaged var channelId: String?
    @NSManaged var videos: NSSet?

}
