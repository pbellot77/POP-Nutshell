//
//  Video+CoreDataProperties.swift
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

extension Video {

    @NSManaged var videoDescription: String?
    @NSManaged var title: String?
    @NSManaged var publishedAt: NSDate?
    @NSManaged var id: String?
    @NSManaged var videoId: String?
    @NSManaged var channel: Channel?
    @NSManaged var thumbnails: Thumbnail?

}
