//
//  PNSVideos.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import Foundation
import CoreData

extension Video {
    
    @NSManaged var videoId: String?
    @NSManaged var videoTitle: String?
    @NSManaged var videoThumbnailUrl: String?
    @NSManaged var videoDescription: String?
    @NSManaged var isFavorite: Bool
    @NSManaged var videoThumbnail: String?
    
    convenience init(videoId: String?, videoTitle: String?, videoThumbnailUrl: String?, videoDescription: String?, videoThumbnail: String?, isFavorite: Bool, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Video", inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.videoId = videoId
        self.videoTitle = videoTitle
        self.videoThumbnailUrl = videoThumbnailUrl
        self.videoDescription = videoDescription
        self.videoThumbnail = videoThumbnail
        self.isFavorite = false
    }
}