//
//  Video+CoreDataProperties.swift
//  
//
//  Created by Patrick Bellot on 6/18/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Video {

    @NSManaged var videoId: String?
    @NSManaged var videoTitle: String?
    @NSManaged var videoThumbnail: String?
    @NSManaged var videoDescription: String?

}
