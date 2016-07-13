//
//  PNSVideo.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/30/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Video: NSManagedObject {
    
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