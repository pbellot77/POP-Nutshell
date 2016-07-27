//
//  Thumbnail+CoreDataProperties.swift
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

extension Thumbnail {

    @NSManaged var width: NSNumber?
    @NSManaged var url: String?
    @NSManaged var size: String?
    @NSManaged var height: NSNumber?
    @NSManaged var high: String?
    @NSManaged var video: Video?

}
